module Shell
  def file_exists?(file)
    test("[ -f #{file} ]")
  end

  def overwrite_file?(file)
    ask(:answer, "File #{file} already exists. Overwrite it? (y/N)")
    fetch(:answer).casecmp("y").zero?
  end

  def file_exists_and_overwrite?(file)
    file_exists?(file) && overwrite_file?(file)
  end

  def file_new_or_overwrite?(file)
    !file_exists?(file) || overwrite_file?(file)
  end
end
