 How To use this app
=============
Setting up the wrapper
-------------
* make sure to set your subdomain in the BASE_URL constant


Finding yourself
-------------
* The first thing you will need to do is locate your API key. Instructions for that can be found [here](http://developer.teamworkpm.net/index.cfm/page/enabletheapiandgetyourkey)

* then you can launch the wrapper and list your projects like so
    ruby uploadtime.rb --api-key <your api key>  --list-projects

* then you can list people in that project like so
    ruby ./uploadtime.rb --api-key <your api key> --project <project number> --list-people

* now you can add your time from a csv file like so
    ruby ./uploadtime.rb --api-key <your api key> --project <project number> --person <your person id> --post-times --file <csv file>

Keep in mind that I have hardcoded the row[id]s hard coded, so you'll want to match mine (commented) or reorder to suit. 

  TODO
  * write tests
  * read and parse csv header to assign rows for json 
