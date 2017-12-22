class Packager
  def initialize(path)
    @path = path
  end

  def wrap_html(response)
    "<html><head></head><body><pre>
    #{response}
    </pre></body></html>"
  end

end
