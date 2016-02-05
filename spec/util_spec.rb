require 'spec_helper'

describe 'Util' do
  def trim(file_name, dir_length)
    file_name = file_name
    ext_name = File.extname file_name
    file_name = File.basename file_name
    output_dir_length = dir_length

    output_length = file_name.length + output_dir_length
    file_name = trim_file(file_name, output_length, ext_name)
    file_name
  end

  it 'trim_file trims paths >255' do
    dir_length = 250
    file_name = trim '123456.uix', dir_length

    expect(file_name.length + dir_length).to eq(255)
    expect(file_name).to eq '1.uix'
  end

  it 'trim_file returns paths <=255' do
    dir_length = 245
    original_file_name = '123456.uix'
    file_name = trim original_file_name, dir_length

    expect(file_name.length + dir_length).to eq(255)
    expect(file_name).to eq original_file_name
  end
end
