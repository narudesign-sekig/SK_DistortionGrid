@version 2.3
@warnings
@script motion
@name SK_DistortionGrid

objId;
positionX, positionY;
desc;

create
{
    for (i = 1; i <= 4; i++)
    {
        objId[i] = nil;
    }
    positionX = 50.0;
    positionY = 50.0;
    desc = "SK Distortion Grid";
    
    updateDesc();
}

updateDesc
{
    setdesc(desc + " X:" + positionX + "%, Y:" + positionY + "%");
}

process: ma, frame, time
{
    if (!objId[1] || !objId[2] || !objId[3] || !objId[4])
    {
        return;
    }
    
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
    cPositionY = ctlnumber("Position Y (%)", positionY);
    
    return if !reqpost();
    
    for (i = 1; i <= 4; i++)
    {
        obj[i] = getvalue(c[i]);
    }
    
    positionX = getvalue(cPositionX);
    positionY = getvalue(cPositionY);
    
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
        positionY = io.read().asNum();
        
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
        io.writeln(positionY);
    }
}