component extends="org.corfield.framework" {
	
	this.mappings["fw1"] = expandpath("../fw1");
	this.mappings["com"] = expandpath("../com");
	this.datasource="todos";
	this.ormenabled="true";
	
	if ( structKeyexists ( URL,"ORMreloadFull" ) ) {	
		this.ormsettings  =   {
            cfclocation="../entities" , 
            savemapping="false" , 
            dbcreate="dropcreate" , 
            sqlscript="dbcreate.sql" , 
            flushatrequestend="false"
        };
	}
	else
	{
        this.ormsettings    =   {
            cfclocation="../entities" , 
            savemapping="false" , 
            dbcreate="update" , 
            flushatrequestend="false"
        };
    };
	
	variables.framework = {
		base = "/fw1/",
		reloadApplicationOnEveryRequest = true ,
		routes = [
		  { "$GET/todo/:id" = "/main/get/id/:id" },
		  { "$GET/todo/" = "/main/list" },
		  { "$DELETE/todo/:id" = "/main/delete/id/:id" },
		  { "$POST/todo/" = "/main/save" },
		  { "$GET/*" = "/main/default/" },
		  { "*" = "/main/default/" }
		]	
	};
	
	function setupApplication() 
	{
		setBeanFactory( new org.corfield.ioc( '/com' ) );
		
	}

	function setupRequest() {

        if (structKeyexists(URL,"ORMreload")) {
			ORMFlush();
			ORMReload();
			}
		if (structKeyexists(URL,"ORMreloadFull")) {
			ORMFlush();
			ORMReload();
			structClear(session);
			redirect('main/default'); 
			}
	}		

	function failure( exception, event ) { // "private"
	
			if ( structKeyExists(exception, 'rootCause') ) {
				exception = exception.rootCause;
			}
			writeOutput( '<h1>Something bad happened in #event#</h1>' );
			if ( structKeyExists( request, 'failedAction' ) ) {
				writeOutput( '<p>The action #request.failedAction# failed.</p>' );
			}
			writeOutput( '<h2>#exception.message#</h2>' );
			writeOutput( '<p>#exception.detail# (#exception.type#)</p>' );
			dumpException(exception);
			dumpException(session);
	
	}
	
}