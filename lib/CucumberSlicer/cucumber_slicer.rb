@tag1
module CucumberSlicer
  class Slicer
    def number_of_files(feature_dir)
      Dir[File.join(feature_dir, '**', '*.feature')].count {|file| File.file? file}
    end

    def all_features(features_dir)
      Dir[File.join(features_dir, '**', '*.feature')].select {|file| File.file? file}
    end

    def slice(number_of_times, features_dir = 'lib', tag_name = 'tag')
      tag_num = 0
      num_files = number_of_files(features_dir)
      split_freq = (num_files.to_f / number_of_times).ceil
      features = all_features features_dir
      features.each_with_index do |file, index|
        s_index = index % split_freq
        tag_num = tag_num + 1 if s_index == 0
        tag = "@#{tag_name + tag_num.to_s}\n"
        new_file_name = file + '.tmp'
        open_file = File.open(file)
        new_file = File.new(new_file_name, 'w')
        new_file << tag
        open_file.each do |line|
          new_file << line unless line.start_with? '@tag'
        end
        new_file.close
        open_file.close
        FileUtils.mv(new_file_name, file)
      end
    end
  end
end