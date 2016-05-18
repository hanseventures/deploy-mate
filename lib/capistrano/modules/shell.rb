module Shell

  def file_exists?(file)
    test("[ -f #{file} ]")
  end

end
