void() Juggernaut_HideHost_Think =
{
    msg_entity = self.owner;

    WriteByte(MSG_ONE,SVC_UPDATENAME);
    WriteByte(MSG_ONE,0);
    WriteString(MSG_ONE,"");
}

float() Juggernaut_GetServerOptions =
{
    return cvar("saved2");
}

float() Juggernaut_IsHostMode =
{
    return Juggernaut_GetServerOptions() & SERVERSETTINGS_HOSTMODE;
}