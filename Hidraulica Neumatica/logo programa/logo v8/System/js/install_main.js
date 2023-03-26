function whatPlatform()
    {

        plat="other";

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
            var MacOSXPlugIn = navigator.plugins["Default Plugin Carbon.cfm"];
            if (MacOSXPlugIn || thisAgent.indexOf("omniweb") != -1 )
            {
                //Change value to true to enable the applet for Mac OS X
                //This variable has been introduced to this page as the support for
                //applets on Mac OS X has been questionable.
                enableAppletForMacOSX = true;
                plat="macosx";
            }
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
            plat="hpux";
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
        if (thisAgent.indexOf("os/390") != -1)
        {
            plat="os390";
        }


        // now determine what platforms are available, and reset the chosen platform based on whether the platform is available
        // if you want the user to get a message that the desired platform is NOT available, set the fallback "plat" to "notavailable"
        // the order is important, as it indicated the fallback order
        // every platform above, must have a fall back below

        platAvail="notavailable";


        platAvail="win";

        if ((plat=="win" || plat=="win64") && (platAvail!="win"))
        {
            plat="other";
        }


        platAvail="macosx";

        if ((plat=="macosx") && (platAvail!="macosx"))
        {
            plat="unix";
        }


        if ((plat=="mac") && (platAvail!="mac"))
        {
            plat="other";
        }


        if ((plat=="solaris") && (platAvail!="solaris"))
        {
            plat="unix";
        }


        if ((plat=="aix") && (platAvail!="aix"))
        {
            plat="unix";
        }


        if ((plat=="digitalunix") && (platAvail!="digitalunix"))
        {
            plat="unix";
        }


        if ((plat=="hpux") && (platAvail!="hpux"))
        {
            plat="unix";
        }


        if ((plat=="sco") && (platAvail!="sco"))
        {
            plat="unix";
        }


        if ((plat=="freebsd") && (platAvail!="freebsd"))
        {
            plat="bsd";
        }


        if ((plat=="openbsd") && (platAvail!="openbsd"))
        {
            plat="bsd";
        }


        if ((plat=="netbsd") && (platAvail!="netbsd"))
        {
            plat="bsd";
        }


        if ((plat=="bsd") && (platAvail!="bsd"))
        {
            plat="unix";
        }


        platAvail="linux";

        if ((plat=="linux") && (platAvail!="linux"))
        {
            plat="unix";
        }


        if ((plat=="reliant") && (platAvail!="reliant"))
        {
            plat="unix";
        }


        if ((plat=="irix") && (platAvail!="irix"))
        {
            plat="unix";
        }


        if ((plat=="os390") && (platAvail!="os390"))
        {
            plat="unix";
        }


        if ((plat=="unix") && (platAvail!="unix"))
        {
            plat="other";
        }


        if ((plat=="other") && (platAvail!="other"))
        {
            plat="notavailable";
        }

        return plat;

    }


function platformButtons()
    {
    
        plat = whatPlatform();

        document.writeln("<font face=\"Arial,Helvetica,Geneva,Swiss,SunSans-Regular\" size=\"3\">");

        if (plat=="win")
        {
            document.writeln("<b>Recommended installer for your platform...</b><br/>");
            document.write("<form method=\"get\" action=\"");

            document.write("InstData/Win32/VM/Setup.exe\">");
            //

            document.writeln("<input type=\"SUBMIT\" value=\"Download Installer for Windows (includes Java VM)\" >");
            //
            document.writeln("<br/></form>");
            document.writeln("Enable Java in your browser to install directly from the web.<br/>");
        }

        if (plat=="win64")
        {
            document.writeln("<b>Recommended installer for your platform...</b><br/>");
            document.write("<form method=\"get\" action=\"");

            document.write("InstData/Win64/VM/Setup.exe\">");
            //

            document.writeln("<input type=\"SUBMIT\" value=\"Download Installer for Windows (includes Java VM)\" >");
            //
            document.writeln("<br/></form>");
            document.writeln("Enable Java in your browser to install directly from the web.<br/>");
        }

        if (plat=="macosx")
        {
            document.writeln("<b>Recommended installer for your platform...</b><br/>");
            document.write("<form method=\"get\" action=\"");

            document.write("InstData/MacOSX/Setup.zip\">");
            //

            document.writeln("<input type=\"SUBMIT\" value=\"Download Installer for Mac OS X (without Java VM)\" ><br/>");
            //
            if( enableAppletForMacOSX )
            {
                document.writeln("<br/></form>");
                document.writeln("Enable Java in your browser to install directly from the web.<br/>");
            }
        }




        if (plat=="linux")
        {
            document.writeln("<b>Recommended installer for your platform...</b><br/>");
            document.write("<form method=\"get\" action=\"");

            document.write("InstData/Linux/VM/Setup.bin\">");
            //

            document.writeln("<input type=\"SUBMIT\" value=\"Download Installer for Linux (includes Java VM)\" ><br/>");
            //
            document.writeln("<br/></form>");
            document.writeln("Enable Java in your browser to install directly from the web.<br/>");
        }



        if (plat=="other")
        {
            document.writeln("<b>Recommended installer for your platform...</b><br/>");
            document.write("<form method=\"get\" action=\"");

            document.write("\">");
            //

            document.writeln("<input type=\"SUBMIT\" value=\"Download Installer ()\" ><br/>");
            //
            document.writeln("<br/></form>");
        }
        if (plat=="notavailable")
        {
            document.writeln("<b>There is no installer available for your platform.<br/>");
            document.writeln("Please select an alternate platform below.</b><br/>");
        }

        document.writeln("</font>");
    }

    

function setArchiveFile()
    {
    
        plat = whatPlatform();  
            
            
        if (plat!="macosx" || ( plat=="macosx" && enableAppletForMacOSX ))
        {
            if (plat!="mac")
            {
                document.writeln("<applet codebase=\"InstData\" archive=\"WebInst.jar\" code=\"com.zerog.ia.download.WebInstallerApplet\" width=\"425\" height=\"85\">");
            }
            if (plat=="mac")
            {
                document.writeln("<applet codebase=\"InstData\" archive=\"WebInstMac.jar\" code=\"com.zerog.ia.download.WebInstallerApplet\" width=\"425\" height=\"85\">");
            }
        }
    }

    
function setArchiveFileEnd()
    {
    
    document.writeln("</applet>");
                
    }

    
    
    
function displayMarker(whatPlat)
    {
        plat = whatPlatform();
    
        if (whatPlat==plat)
        {
            document.write("<font face=\"Arial,Helvetica,Geneva,Swiss,SunSans-Regular\" color=\"green\"><b>&gt</b></font>");
        }
    }


    
    
    
function setPlatFont(whatPlat)
    {

        plat = whatPlatform();
        
        if (whatPlat==plat)
        {
            document.write("<font face=\"Arial,Helvetica,Geneva,Swiss,SunSans-Regular\" color=\"green\"><b>")
        }
        else
        {
            document.write("<font face=\"Arial,Helvetica,Geneva,Swiss,SunSans-Regular\" >")
        }
    }

    
    
    
function endPlatFont(whatPlat)
    {
    
        plat = whatPlatform();
    
        if (whatPlat==plat)
        {
            document.write("</b></font>")
        }
        else
        {
            document.write("</font>")
        }
    }



// Sollte für die INstallation über das Applet kein Java vorhanden sein,
// so sollen alternative Anweisungen zur Installation angezeigt werden.

function ShowAlternativeInstrIfJavaNotEnabled()
{
            if(!navigator.javaEnabled())
            {
            
            var plat;
            var language;
            plat = whatPlatform();
            language = ConvertLangId(GetLang());
            parent.location.href="../framewin_noinfo.htm?URL=installer/alt_instructions/alt_inst_" + plat + "_" + language + ".htm";
            }
  
}



//Sprach-Id-Konvertierung von Web-Norm nach Java-Norm

function ConvertLangId(sLangauge)
{
        
        switch(sLangauge) {
         case "de":
            sLangauge = "de_DE";
         break;
         case "en":
            sLangauge = "en_US";
         break;
         case "es":
            sLangauge = "es_ES";
         break;
         case "fr":
            sLangauge = "fr_FR";
         break;
         case "it":
            sLangauge = "it_IT";
         break;
         
         default:
            sLangauge = "en_US";
         break;
         
         }
         
    return sLangauge;

}
      
    
// Liefert die Sprache des Browsers

function GetLang()
{
     var sLangauge = ""; 

     if(navigator.appName=="Microsoft Internet Explorer") 
     {
           // Internet Explorer
           sLangauge = navigator.userLanguage;
     }
     else  
     {
           if(navigator.appName=="Netscape" || navigator.appName=="Konqueror")
           {
                   // Netscape, Konqueror
                   sLangauge = navigator.language;
           }
           else
           {
                   // Others
                   sLangauge = navigator.userLanguage;
           }
     }         
     
    return sLangauge;     
     
}              