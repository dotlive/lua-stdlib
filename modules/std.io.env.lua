-- Environment

require "std.data.list"


-- shell: Perform a shell command and return its output
--   c: command
-- returns
--   o: output, or nil if error
function shell (c)
  local h = io.popen (c)
  local o
  if h then
    o = h:read ("*a")
    h:close ()
  end
  return o
end

-- processFiles: Process files specified on the command-line
-- file name "-" means io.stdin
--   f: function to process files with
--     name: the name of the file being read
--     i: the number of the argument
function processFiles (f)
  for i = 1, table.getn (arg) do
    if arg[i] == "-" then
      io.input (io.stdin)
    else
      io.input (arg[i])
    end
    prog.file = arg[i]
    f (arg[i], i)
  end
end

-- shift: Remove elements from the start of arg
--   [n]: number of elements to remove [1]
function shift (n)
  behead (arg, n)
end

-- readDir: Make a list of a directory's contents
--   d: directory
-- returns
--   l: list of files
function readDir (d)
  local l = split ("\n", chomp (shell ("ls -aU " .. d ..
                                       " 2>/dev/null")))
  table.remove (l, 1) -- remove . and ..
  table.remove (l, 1)
  return l
end
