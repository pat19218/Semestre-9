function whatPlatform()
{

    var plat="other";

    thisAgent = navigator.userAgent.toLowerCase();

    // the order of the names is important, since these are not nested ifs

    if (thisAgent.indexOf("win") != -1)
    {
        plat="win";
    }
    if (thisAgent.indexOf("95") != -1)
    {
        plat="win";
    }
    if (thisAgent.indexOf("98") != -1)
    {
        plat="win";
    }
    if (thisAgent.indexOf("nt") != -1)
    {
        plat="win";
    }
    if (plat=="win") {
    	if (thisAgent.indexOf("wow64") != -1 || thisAgent.indexOf("win64") != -1) {
    		plat="win64";
    	}
    }


    if (thisAgent.indexOf("mac") != -1)
    {
        plat="mac";
    }

    if (thisAgent.indexOf("sun") != -1)
    {
        plat="solaris";
    }
    if (thisAgent.indexOf("solaris") != -1)
    {
        plat="solaris";
    }
    if (thisAgent.indexOf("aix") != -1)
    {
        plat="aix";
    }
    if (thisAgent.indexOf("ibm") != -1)
    {
        plat="aix";
    }
    if (thisAgent.indexOf("dec") != -1)
    {
        plat="digitalunix";
    }
    if (thisAgent.indexOf("osf") != -1)
    {
        plat="digitalunix";
    }

    if (thisAgent.indexOf("digital") != -1)
    {
        plat="digitalunix";
    }
    if (thisAgent.indexOf("hp") != -1)
    {
        plat="hp";
    }
    if (thisAgent.indexOf("unix") != -1)
    {
        plat="unix";
    }
    if (thisAgent.indexOf("sco") != -1)
    {
        plat="sco";
    }
    if (thisAgent.indexOf("bsd") != -1)
    {
        plat="bsd";
    }
    if (thisAgent.indexOf("free") != -1)
    {
        plat="freebsd";
    }
    if (thisAgent.indexOf("open") != -1)
    {
        plat="openbsd";
    }
    if (thisAgent.indexOf("netbsd") != -1)
    {
        plat="netbsd";
    }
    if (thisAgent.indexOf("linux") != -1)
    {
        plat="linux";
    }
    if (thisAgent.indexOf("reliant") != -1)
    {
        plat="reliant";
    }

    if (thisAgent.indexOf("sgi") != -1)
    {
        plat="irix";
    }
    if (thisAgent.indexOf("silicon") != -1)
    {
        plat="irix";
    }
    if (thisAgent.indexOf("irix") != -1)
    {
        plat="irix";
    }
    if (thisAgent.indexOf("os/2") != -1)
    {
        plat="os2";
    }
    if (thisAgent.indexOf("os/390") != -1)
    {
        plat="os390";
    }


    // now determine what platforms are available, and reset the chosen platform based on whether the platform is available
    // if you want the user to get a message that the desired platform is NOT available, set the fallback "plat" to "notavailable"
    // the order is important, as it indicated the fallback order
    // every platform above, must have a fall back below

    platAvail="notavailable"

//
    platAvail="win";
//
    if ((plat=="win" || plat=="win64") && (platAvail!="win"))
    {
        plat="other";
    }

//
    platAvail="mac"
//
    if ((plat=="mac") && (platAvail!="mac"))
    {
        plat="other";
    }

//
    if ((plat=="solaris") && (platAvail!="solaris"))
    {
        plat="unix";
    }

//
    if ((plat=="aix") && (platAvail!="aix"))
    {
        plat="unix";
    }

//
    if ((plat=="digitalunix") && (platAvail!="digitalunix"))
    {
        plat="unix";
    }

//
    if ((plat=="hp") && (platAvail!="hp"))
    {
        plat="unix";
    }

//
    if ((plat=="sco") && (platAvail!="sco"))
    {
        plat="unix";
    }

//
    if ((plat=="freebsd") && (platAvail!="freebsd"))
    {
        plat="bsd";
    }

//
    if ((plat=="openbsd") && (platAvail!="openbsd"))
    {
        plat="bsd";
    }

//
    if ((plat=="netbsd") && (platAvail!="netbsd"))
    {
        plat="bsd";
    }

//
    if ((plat=="bsd") && (platAvail!="bsd"))
    {
        plat="unix";
    }

//
    platAvail="linux"
//
    if ((plat=="linux") && (platAvail!="linux"))
    {
        plat="unix"
    }

//
    if ((plat=="reliant") && (platAvail!="reliant"))
    {
        plat="unix";
    }

//
    if ((plat=="irix") && (platAvail!="irix"))
    {
        plat="unix";
    }

//
    if ((plat=="os390") && (platAvail!="os390"))
    {
        plat="unix";
    }

//
    if ((plat=="unix") && (platAvail!="unix"))
    {
        plat="other";
    }

//
//  if ((plat=="os2") && (platAvail!="os2"))
//  {
//      plat="other";
//  }

//
    if ((plat=="other") && (platAvail!="other"))
    {
        plat="notavailable";
    }


return plat;

}





function isActive(aname)
{
    var i = 0;
    var ergebnis = false;
    for (i=0; i<document.anchors.length; i++){
    if (document.anchors[i].name==aname)
    ergebnis = true;
    }
    return ergebnis;
}

function isActive_skipLast(aname)
{
    var i = 0;
    var ergebnis = false;
    for (i=0; i<(document.anchors.length-1); i++){
    if (document.anchors[i].name==aname)
    ergebnis = true;
    }
    return ergebnis;
}



// Das dynamische Auskommentieren von Code:

function StartCommentIfSystemNotMatch(sValOs, sValBrowser, sValGroupId)
{
     // sValBrowser auf den aktuellen Browsertyp stezen, wenn sValBrowser nicht angegeben
     if ((sValBrowser=="") || (sValBrowser=="all")){
        sValBrowser = navigator.appName;
     }

     // sValOs auf das aktuelle Betriebssystem stezen, wenn sValOs nicht angegeben
     if ((sValOs=="") || (sValOs=="all")){
        sValOs = whatPlatform();
     }
        
     if (isActive(sValGroupId)){
           document.write("<!--");
            return;
     }
        
     if ((sValOs!=whatPlatform()) || (navigator.appName!=sValBrowser)){
            document.write("<!--");
     }
}

function EndCommentIfSystemNotMatch(sValOs, sValBrowser, sValGroupId)
{
     // sValBrowser auf den aktuellen Browsertyp stezen, wenn sValBrowser nicht angegeben
     if ((sValBrowser=="") || (sValBrowser=="all")){
        sValBrowser = navigator.appName;
     }

     // sValOs auf das aktuelle Betriebssystem stezen, wenn sValOs nicht angegeben
     if ((sValOs=="") || (sValOs=="all")){
        sValOs = whatPlatform();
     }
     
     if (isActive_skipLast(sValGroupId)){
    document.write("-->");
            return;

     }

     if ((sValOs!=whatPlatform()) || (navigator.appName!=sValBrowser)){
            document.write("-->");
     }
     
}


