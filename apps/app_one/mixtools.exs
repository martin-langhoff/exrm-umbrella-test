defmodule AppOne.MixTools do
  def get_version do
    IO.puts "get_version"
  # System.cmd/3 will have two error modes here
  #  - raises ErlangError :enoent if git is not installed
  #  - completes w non-zero exitcode if git does not find
  #    git checkout
    {raw_ver, exitcode} = try do
      {_ver, _exitcode}  = System.cmd "git", ["describe", "--always", "--tags"]
    rescue
      ErlangError -> {"", 1}
    end

    if exitcode === 0 do
      # If git debscribe returns a 'snapshot' version,
      # replace the first '-' after the tag with a '+'.
      #
      # Using a '+' fits with SemVer -- if the tag is SemVer,
      # then a snapshot built after it will have a snapshot
      # 'version' that is valid SemVer.
      #
      # As the tag can be anything, we find the correct '-'
      # to replace by anchoring the regex on the right
      # and scanning for the components of the git describe suffix
      # (number of patches, 'g', 7 chars of commithash)
      ver = Regex.replace(~r/-(\d+-g\w{7}$)/,
                          String.strip(raw_ver, ?\n),
                          "+\\1", [:all])

      ver = if String.starts_with?(ver, "v") do
        String.slice(ver, 1, 100)
      else
        ver
      end

      {:ok, fh} = File.open "app.version", [:write]
      IO.binwrite fh, ver
      File.close fh
      ver
    else
      {:ok, ver} = File.read "app.version"
      String.strip(ver, ?\n)
    end
  end
end
