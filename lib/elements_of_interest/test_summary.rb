require 'rubygems'
require 'plist'
require 'fileutils'
require 'shellwords'
require 'pry' rescue nil

module ElementsOfInterest
  class TestSummary
    include Util
    attr_reader :summary_file, :output_folder, :parsed, :attachments_folder,
                :prefix, :class_name, :test_name, :log

    def summary_file_from_project(project_name)
      return project_name if File.exist?(project_name)
      # Xcode has multiple duplicate project names because why not.
      projects = []
      Dir.glob(File.join(Dir.home, 'Library/Developer/Xcode/DerivedData', "#{project_name}*")) do |target|
        projects << [target, File.mtime(target)] if File.directory?(target)
      end

      project = projects.sort_by { |_, time| time }.last # [path, time]
      project = project.first if project # time
      fail "Project not found: #{project_name}" unless project
      # Xcode also keeps multiple test summaries. Pick the most recent one
      summaries = []
      Dir.glob(File.join(project, 'Logs/Test/*_TestSummaries.plist')) do |target|
        summaries << [target, File.mtime(target)] if File.file?(target)
      end
      summary = summaries.sort_by { |_, time| time }.last # [path, time]
      summary = summary.first if summary # time
      fail "Summary not found #{summary}" unless summary
      summary
    end

    def initialize(project_name)
      @summary_file = summary_file_from_project project_name
      fail "File doesn't exist: #{summary_file}" unless File.exist?(summary_file)

      @parsed = Plist.parse_xml summary_file
      @output_folder = get_output_folder parsed
      input_folder = File.expand_path File.dirname summary_file
      @attachments_folder = File.join input_folder, 'Attachments'

      copy_file summary_file, 'summary.plist'
    end

    def write_file(file_name, content)
      file_dst = File.join(output_folder, file_name)
      output_dir = File.dirname(file_dst)
      FileUtils.mkdir_p output_dir

      # fix: File name too long @ rb_sysopen (255 max)
      ext_name = File.extname file_name
      file_name = File.basename file_name

      output_length = file_name.length + output_dir.length
      file_name = trim_file(file_name, output_length, ext_name)
      file_dst = File.join(output_dir, file_name)

      File.open(file_dst, 'w') { |f| f.write content }
    end

    def copy_file(file_src, file_dst)
      file_dst = file_dst.include?(output_folder) ? file_dst : File.join(output_folder, file_dst)
      FileUtils.mkdir_p File.dirname(file_dst)
      FileUtils.cp file_src, file_dst
    end

    def converter
      return @converter if @converter
      path = File.expand_path(File.join(__dir__, '..', 'swift_bin', 'elements_of_interest'))
      path = File.expand_path(File.join(__dir__, '..', '..', 'swift_bin', 'elements_of_interest')) unless File.exist?(path)
      fail "Failed to find converter #{path}" unless File.exist?(path)
      @converter = path
    end

    def snapshot_to_uix(input_snapshot, output_uix)
      input_snapshot = input_snapshot.shellescape
      fail "Input doesn't exist" unless File.exist?(input_snapshot)
      output_uix = File.join(output_folder, output_uix).gsub(':', ';')
      output_dir = File.dirname(output_uix)
      output_name = File.basename(output_uix)
      output_length = (output_dir + output_name).length
      # Fix File name too long @ rb_sysopen.
      output_name = trim_file(output_name, output_length, '.uix')
      output_uix = File.join(output_dir, output_name)

      cmd = %(#{converter} "#{input_snapshot}" #{output_uix.shellescape})
      `#{cmd}`
    end

    def get_output_folder(parsed)
      target_device = parsed['RunDestination']['TargetDevice']
      model = target_device['ModelName'] # iPhone 4s
      os = target_device['OperatingSystemVersionWithBuildNumber'] # "9.2 (13C75)"
      platform_name = target_device['Platform']['Name'] # "iOS Simulator"
      target_name = parsed['TestableSummaries'].first['TargetName'] # "iCanvasUITests"
      time = Time.now.ctime.gsub(':', ';') # OS X doesn't like : in file names

      folder = [model, os, platform_name, target_name, time].join ' '
      result = File.expand_path(File.join(Dir.home, 'elements_of_interest', folder))
      FileUtils.mkdir_p result
      result
    end

    def process_sub_activity(sub_activity)
      if sub_activity.is_a?(Array)
        sub_activity.each { |act| process_sub_activity act }
        return
      end

      # "username and/or password" - the '/' will mess up file methods.
      # ':' isn't allowed in OS X file names
      title = sub_activity['Title'].gsub(':', ';').gsub('/', '_')
      log.puts "  title: #{title}"

      attachments = sub_activity['Attachments'] || []

      # next unless attachments.length >= 2
      prefix_string = prefix.to_s # zero pad starting number
      prefix_string = '0' * (3 - prefix_string.length) + prefix_string if prefix_string.length < 3

      has_eoe = !!sub_activity['HasElementsOfInterest']
      has_screenshot = !!sub_activity['HasScreenshotData']
      has_snapshot = !!sub_activity['HasSnapshot']
      # also: HasSynthesizedEvent but we don't decode those.

      uuid = sub_activity['UUID']

      last_snapshot = nil
      save_snapshot = has_eoe || has_snapshot

      # elements of interest & snapshots are the same format
      # HasSnapshot is only used when HasSynthesizedEvent is true otherwise it's HasElementsOfInterest
      if save_snapshot
        snapshot = "ElementsOfInterest_#{uuid}" if has_eoe
        snapshot = "Snapshot_#{uuid}" if has_snapshot
        fail 'snapshot not found' unless snapshot

        snapshot_file_src = File.expand_path(File.join(attachments_folder, snapshot))
        # don't expand path since copy_file prepends output folder
        snapshot_file_dst = File.join(class_name, test_name, "#{prefix_string}_#{title}.uix")
        snapshot_to_uix snapshot_file_src, snapshot_file_dst
        last_snapshot = snapshot_file_dst
        log.puts ' ' * 4 + snapshot
      end

      if has_screenshot
        screenshot = screenshot ? screenshot['FileName'] : "Screenshot_#{uuid}.png"
        screenshot_file_src = File.expand_path(File.join(attachments_folder, screenshot))
        screenshot_file_dst_name = "#{prefix_string}_#{title}.png"
        # don't expand path since copy_file prepends output folder
        screenshot_file_dst = File.join(class_name, test_name, screenshot_file_dst_name)
        copy_file screenshot_file_src, screenshot_file_dst
        log.puts ' ' * 4 + screenshot

        if save_snapshot # we have a screenshot/snapshot pair. unfortunately they don't match up at all.
          pair_folder = File.join(output_folder, File.dirname(screenshot_file_dst), '0_0pair')
          FileUtils.mkdir_p pair_folder
          full_screenshot_dst = File.join(output_folder, screenshot_file_dst)
          full_snapshot_dst = File.join(output_folder, last_snapshot)
          copy_file full_screenshot_dst, File.join(pair_folder, screenshot_file_dst_name)
          copy_file full_snapshot_dst, File.join(pair_folder, File.basename(last_snapshot))
        end
      end

      # some steps have neither snapshot nor screenshot
      if !snapshot && !screenshot
        txt_name = File.join(class_name, test_name, "#{prefix_string}_#{title}.txt")
        write_file txt_name, attachments
      end

      @prefix += 1

      (sub_activity['SubActivities'] || []).each do |act|
        process_sub_activity act
      end
    end

    def parse_test_summaries
      summaries = parsed['TestableSummaries']
      @log = StringIO.new

      test_count = 0
      successful_tests = []
      failed_tests = []

      # TestableSummaries -> Tests -> Subtests -> Subtests

      summaries.each do |summary|
        log.puts "Project: #{summary['TestName']}" # "iCanvasUITests"
        all_tests = summary['Tests'].first
        sub_tests = all_tests['Subtests'] || []

        sub_tests.each do |test_class|
          # test["TestName"]       => "testLogin_rejectsInvalidCredentials()"
          # test["TestIdentifier"] => "LoginTests/testLogin_rejectsInvalidCredentials()"
          @class_name = test_class['TestName']
          log.puts "Class: #{class_name}"

          (test_class['Subtests'] || []).each do |test_method|
            @test_name = test_method['TestName']
            test_identifier = test_method['TestIdentifier']
            log.puts "Test method: #{test_identifier}"
            @prefix = 0

            # If a test has sub activities then track if it ran successfully or failed
            failures = test_method['FailureSummaries'] || []
            if failures.length > 0
              failed_tests << [test_identifier, failures.map { |f| f['Message'] }]
            else
              successful_tests << test_identifier
            end
            test_count += 1

            (test_method['ActivitySummaries'] || []).each do |act_summary|
              sub_activities = act_summary['SubActivities']
              next unless sub_activities

              process_sub_activity sub_activities
            end # (test_method['ActivitySummaries'] || []).each do |summary|
          end # (test_class['Subtests'] || []).each do |test_method|
        end # (project['Subtests'] || []).each do |test_class|
      end # summaries.each do |summary|

      prefix = StringIO.new
      prefix.puts File.dirname(summary_file)
      prefix.puts
      prefix.puts "#{test_count} tests. #{successful_tests.length} successful, #{failed_tests.length} failed"
      prefix.puts
      prefix.puts 'Failed tests:'
      failed_tests.each do |test_id, fail_messages|
        prefix.puts test_id
        prefix.puts "    #{fail_messages.join("\n")}"
      end
      prefix.puts

      write_file 'summary.txt', prefix.string + log.string
    end # def self.parse_test_summaries file
  end # class TestSummary
end # module ElementsOfInterest

# Uncomment for easy debugging in RubyMine
# ElementsOfInterest::TestSummary.new('projectName').parse_test_summaries
