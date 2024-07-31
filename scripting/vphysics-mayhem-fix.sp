#include <sourcemod>

public Plugin myinfo =
{
	name = "VPhysics Mayhem Bug Fix",
	author = "Dysphie",
	description = "Fixes a bug that causes physics objects to bounce around or phase through the world",
	version = "1.0.0",
	url = ""
};

Address addr;

public void OnPluginStart()
{
	GameData gamedata = new GameData("vphysics-mayhem-fix.games");
	if (!gamedata) SetFailState("Failed to read gamedata/vphysics-mayhem-fix.txt");

	addr = gamedata.GetAddress("IVP_Mindist_Manager::recheck_ov_element");
	if (!addr) SetFailState("Failed to get address to IVP_Mindist_Manager::recheck_ov_element");

	int val = LoadFromAddress(addr, NumberType_Int8);
	if (val != 1 && val != 0) SetFailState("Failed to verify bytes (expected 1 or 0, got %x)", val);
	
	StoreToAddress(addr, false, NumberType_Int8);
	delete gamedata;
}

public void OnPluginEnd()
{
	StoreToAddress(addr, true, NumberType_Int8);
}