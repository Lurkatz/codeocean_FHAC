class PyLintAdapter < TestingFrameworkAdapter
  REGEXP = /Your code has been rated at (\d+\.?\d*)\/(\d+\.?\d*)/
  ASSERTION_ERROR_REGEXP = /^.*?\(.*?,\ (.*?),.*?\)\ (.*?)$/m

  def self.framework_name
    'PyLint'
  end

  def parse_output(output)
    captures = REGEXP.match(output[:stdout]).captures.map(&:to_f)
    count = captures.second
    passed = captures.first
    failed = count - passed
    assertion_error_matches = output[:stdout].scan(ASSERTION_ERROR_REGEXP).map { |match|
      test = match.first.strip
      description = match.second.strip
      "#{test}: #{description}"
    }.flatten || []
    {count: count, failed: failed, error_messages: assertion_error_matches}
  end
end
