var guidService = (function(){
    var guidInstance;
    function init(){
        var GuidList = [];
        function getNextBlock(){            
          var url = getRootUrl() + "api/guid/requestblock"
          var request = new XMLHttpRequest();
          request.open('GET', url, false);  // `false` makes the request synchronous
          request.send(null);
          if (request.status === 200) {            
              var arr = JSON.parse(request.responseText);
              var i;                       
              for(i = 0; i < arr.length; i++) {                           
                  GuidList.push(arr[i]);                
              }
          }
          else{
              //TODO:  Figure out how to really handle the errors
              console.log('error code', error.status); // xhr.status
              console.log('error description', error.statusText); // xhr.status
          }             
        } 
        function nextBlock()
        {
            var rval; 
            if(GuidList.length<5)
            {
                getNextBlock();
                rval = GuidList.pop();
                
            }
            else{
                rval = GuidList.pop();
            }
            return rval;
        }      
        return {
            getNextGuid: function(){
                return  nextBlock();
            }
        }; 
    };       
    return {

   // Get the Singleton instance if one exists
    // or create one if it doesn't
    getInstance: function () {

      if ( !guidInstance ) {
        guidInstance = init();
      }

      return guidInstance;
    }
  };
})();

function getRootUrl() {
    return window.location.origin 
        ? window.location.origin + '/'
        : window.location.protocol + '/' + window.location.host + '/';
}

//var singleA = guidService.getInstance().getNextGuid();