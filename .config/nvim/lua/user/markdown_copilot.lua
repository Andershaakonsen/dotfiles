local working_directory = vim.fn.getcwd()

-- Check if the working directory contains 'second-brain'
if string.find(working_directory, "/Users/andershakonsen/second") then
	print("This directory contains '/Users/andershakonsen/second'")
	vim.g.copilot_enabled = 0
else
	print("This directory does not contain 'second-brain'")
end
-- Kjører når nvim åpnes
