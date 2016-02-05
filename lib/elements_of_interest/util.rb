module ElementsOfInterest
  module Util
    # Fixes File name too long @ rb_sysopen (255 max)
    #
    # Trims the file name for given output path to ensure the overall path is < 255
    # @param file_name [String] file name including ext. ex: somefile
    # @param output_lenght [String] the length of the path (file name.length + output_dir.length)
    # @param ext_name [String] extension for the file. ex: '.uix'
    def trim_file(file_name, output_length, ext_name)
      result = file_name
      result = file_name[0..254 - output_length - ext_name.length] + ext_name if output_length > 255
      result
    end
  end
end
