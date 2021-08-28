defmodule NbgExrp.FileStorage do
  @tmp_dir "/tmp"
  @today Date.utc_today()

  def store(data) do
    File.open(
      file_name(),
      [
	:read,
	:write
      ],
      fn file -> IO.binwrite(file, data) end
    )
  end

  def read do
    File.open(file_name(), [:read], fn file ->
      IO.binread(file, :line)
    end)
  end

  defp file_name do
    if Application.get_env(:my_app, :environment) == :test do
      "#{@tmp_dir}/nbg-test-#{@today.year}-#{@today.month}-#{@today.day}.json"
    else
      "#{@tmp_dir}/nbg-#{@today.year}-#{@today.month}-#{@today.day}.json"
    end
  end
end
