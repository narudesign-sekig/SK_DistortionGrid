@version 2.3
@warnings
@script motion
@name SK_DistortionGrid

desc = "SK Distortion Grid";

objId;
positionX, positionZ;

create
{
    for (i = 1; i <= 4; i++)
    {
        objId[i] = nil;
    }
    positionX = 50.0;
    positionZ = 50.0;
    
    updateDesc();
}

updateDesc
{
    setdesc(desc + " X:" + positionX + "%, Z:" + positionZ + "%");
}

process: ma, frame, time
{
    for (i = 1; i <= 4; i++)
    {
        if (!objId[i])
            return;
    }
    
    for (i = 1; i <= 4; i++)
    {
        obj[i] = searchObject(objId[i]);
        if (!obj[i])
            return;
    }
    
    pos1 = obj[1].getWorldPosition(time);
    pos2 = obj[2].getWorldPosition(time);
    x = pos1.x + (pos2.x - pos1.x) * positionZ / 100.0;
    z = pos1.z + (pos2.z - pos1.z) * positionZ / 100.0;
    posA = <x, 0, z>;
    
    pos1 = obj[3].getWorldPosition(time);
    pos2 = obj[4].getWorldPosition(time);
    x = pos1.x + (pos2.x - pos1.x) * positionZ / 100.0;
    z = pos1.z + (pos2.z - pos1.z) * positionZ / 100.0;
    posB = <x, 0, z>;

    x = posA.x + (posB.x - posA.x) * positionX / 100.0;
    z = posA.z + (posB.z - posA.z) * positionX / 100.0;
    posC = <x, 0, z>;
    
    ma.set(POSITION, posC);
    return;
    
    x = 0;
    obj1 = searchObject(objId[1]);
    
    if (obj1)
    {
        x = obj1.getWorldPosition(time);
    }
    ma.set(POSITION, <x, 0, 0>);
}

options
{
    reqbegin("SK Distortion Grid");
    
    for (i = 1; i <= 4; i++)
    {
        obj[i] = searchObject(objId[i]);
    }
    
    c[1] = ctlallitems("Corner00", obj[1]);
    c[2] = ctlallitems("Corner01", obj[2]);
    c[3] = ctlallitems("Corner10", obj[3]);
    c[4] = ctlallitems("Corner11", obj[4]);
    cPositionX = ctlnumber("Position X (%)", positionX);
    cPositionZ = ctlnumber("Position Z (%)", positionZ);
    
    return if !reqpost();
    
    for (i = 1; i <= 4; i++)
    {
        obj[i] = getvalue(c[i]);
    }
    
    positionX = getvalue(cPositionX);
    positionZ = getvalue(cPositionZ);
    
    updateDesc();
    
    for (i = 1; i <= 4; i++)
    {
        objId[i] = nil;
        if (obj[i]) objId[i] = getvalue(c[i]).id;
    }
    
    reqend();
}

searchObject: id
{
    obj = Mesh();
    while(obj)
    {
        if (obj.id == id)
        {
            return(obj);
        }
        obj = obj.next();
    }
    return(nil);
}

load: what, io
{
    if (what == SCENEMODE)
    {
        for (i = 1; i <= 4; i++)
        {
            objId[i] = io.read();
        }
        positionX = io.read().asNum();
        positionZ = io.read().asNum();
        
        updateDesc();
    }
}

save: what, io
{
    if (what == SCENEMODE)
    {
        for (i = 1; i <= 4; i++)
        {
            io.writeln(objId[i].asStr());
        }
        io.writeln(positionX);
        io.writeln(positionZ);
    }
}