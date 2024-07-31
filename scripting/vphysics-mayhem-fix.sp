#include <sourcemod>

#define JZ 0x74
#define JMP 0xEB

public Plugin myinfo =
{
	name = "VPhysics Mayhem Bug Fix",
	author = "Dysphie",
	description = "Fixes a bug that causes physics objects to bounce around or phase through the world",
	version = "1.0.1",
	url = ""
};

Address addr;

public void OnPluginStart()
{
	GameData gamedata = new GameData("vphysics-mayhem-fix.games");
	if (!gamedata) SetFailState("Failed to read gamedata/vphysics-mayhem-fix.txt");

	addr = gamedata.GetAddress("IVP_Mindist::do_impact");
	if (!addr) SetFailState("Failed to get address to IVP_Mindist::do_impact");

	int val = LoadFromAddress(addr, NumberType_Int8);
	if (val != JZ) SetFailState("Failed to verify byte (expected %x, got %x)", JZ, val);
	
	StoreToAddress(addr, JMP, NumberType_Int8);
	delete gamedata;
}

public void OnPluginEnd()
{
	StoreToAddress(addr, JZ, NumberType_Int8);
}