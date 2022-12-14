@version 2.3
@warnings
@script motion
@name SK_DistortionGrid

objId;

create
{
    setdesc("SK Distortion Grid");
}

process: ma, frame, time
{
    x = 0;
    obj = searchObject(objId);
    
    if (obj)
    {
        x = obj.getWorldPosition(time);
    }
    ma.set(POSITION, <x, 0, 0>);
}

options
{
    reqbegin("SK Distortion Grid");
    
    obj = searchObject(objId);
    
    c1 = ctlallitems("Corner00", obj);
    return if !reqpost();
    
    objId = getvalue(c1).id;
    
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
        objId = io.read();
    }
}

save: what, io
{
    if (what == SCENEMODE)
    {
        io.writeln(objId.asStr());
    }
}