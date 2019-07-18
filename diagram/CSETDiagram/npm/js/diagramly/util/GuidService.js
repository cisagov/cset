var guidService = (function(){
    var guidInstance;
    function init(){
        var GuidList = [];
        function getNextBlock(){
            return new Promise( resolve => {
                    atomic(getRootUrl() + "api/guid/requestblock").then(
                    function (response) {                    
                        var i;
                        var arr = response.data;
                        for(i = 0; i < arr.length; i++) {                           
                            GuidList.push(arr[i]);                
                        }

                        resolve(GuidList.pop());
                    }).catch(function (error){
                        //TODO:  Figure out how to really handle the errors
                        console.log('error code', error.status); // xhr.status
                        console.log('error description', error.statusText); // xhr.status
                    })                
            });         
        } 
        async function nextBlock()
        {
            var rval; 
            if(GuidList.length<5)
            {
                const v = await getNextBlock();
                v.then(x=> console.log(x));
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

var singleA = guidService.getInstance();
console.log("next guid" + singleA.getNextGuid());

function resolveAfter2Seconds() {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve('resolved');
      }, 2000);
    });
  }
  
  async function asyncCall() {
    console.log('calling');
    var result = await resolveAfter2Seconds();
    console.log(result);
    // expected output: 'resolved'
  }
  
  asyncCall();