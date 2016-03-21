module CucumberSlicer
  def number_of_files(feature_dir)
    Dir[File.join(feature_dir, '**', '*.feature')].count {|file| File.file? file}
  end

  def all_features(features_dir)
    Dir[File.join(features_dir, '**', '*.feature')].select {|file_name| File.file? file_name}
  end

  def temp_file_name(file_name)
    file_name + '.tmp'
  end

  def copy_to_temp(file_name)
    new_file_name = temp_file_name file_name
    FileUtils.copy file_name, new_file_name
    new_file_name
  end

  def generate_tag(tag_name, file_number, split_freq)
    tag_num = file_number % split_freq
    "@#{tag_name + tag_num.to_s}\n"
  end

  def prepend_tag(file_name, tag, feature_text)
    file = File.open(file_name, 'w')
    file << tag
    file << feature_text
    file.close
  end

  def get_file_lines(file_name)
    file = File.open(file_name)
    lines = file.readlines
    file.close
    lines
  end

  def slice(number_of_times, features_dir = 'lib', tag_name = 'tag')
    features = all_features features_dir
    features.each_with_index do |file_name, index|
      tag = generate_tag(tag_name, index, number_of_times)
      new_file_name = copy_to_temp(file_name)
      file_lines = get_file_lines(new_file_name)
      prepend_tag(file_name, tag, file_lines.join(''))
    end
  end

  def reconstruct(features_dir = 'lib')
    features = all_features features_dir
    features.each do |file_name|
      File.delete file_name
      temp_file = temp_file_name file_name
      File.rename(temp_file, file_name)
    end
  end

end