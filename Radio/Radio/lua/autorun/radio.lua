if SERVER then
	include("../radio/sv_init.lua")
else
	include("../radio/cl_init.lua")
end