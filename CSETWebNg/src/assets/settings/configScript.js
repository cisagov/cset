module.exports = {
  getConfigs: getConfigs
};

function isElectron() {
  // Renderer process
  if (typeof window !== 'undefined' && typeof window.process === 'object' && window.process.type === 'renderer') {
      return true;
  }

  // Main process
  if (typeof process !== 'undefined' && typeof process.versions === 'object' && !!process.versions.electron) {
      return true;
  }

  // Detect the user agent when the 'nodeIntegration' option is set to true
  if (typeof navigator === 'object' && typeof navigator.userAgent === 'string' && navigator.userAgent.indexOf('Electron') >= 0) {
      return true;
  }

  return false;
}

function processDataOverrides(source, data) {
  //get the base object
  //get the string of overrides
  //for each over
  //get all the properties
  //for each property if the property has properites
  //then recurse
  //else set the property value on the base object from the override
  for (const property in source) {
    if (property.startsWith("answers")) {
      //console.log("skipping overload for " + property);
    } else {
      if (typeof source[property] == "object") {
        processDataOverrides(source[property], data[property]);
      } else {
        //console.log(`copying source ${property} was:${data[property]} now is:${source[property]}`);
        data[property] = source[property];
      }
    }
  }

  return data;
}

async function getConfig(configURL) {
  const response = await fetch(configURL);
  const tmpConfig = await response.json();
  return tmpConfig;
}

async function getConfigs(masterConfig, configChain) {
  // console.log("processing the chain");
  // console.log(configChain);
  // console.log("for master config");
  // console.log(masterConfig);
  for (var config of configChain) {
    var isElectronVar = isElectron();
    var leading = isElectronVar?"":"/";
    var tmpURL = leading + `assets/settings/config.${config}.json`;

    //console.log("getting" + tmpURL);
    var tmpConfig = await getConfig(tmpURL).then((data) => {
      //console.log("applying:" + config);
      //console.log(data);
      masterConfig = processDataOverrides(data, masterConfig);
    });
  }
  //console.log("final config");
  //console.log(masterConfig);
}

function switchConfigsForMode(installationMode) {  
  switch (installationMode) {
    case "ACET":
      {
        var x = document.getElementsByClassName("root");
        if (x.length > 0) {
          x[0].classList.add("acet-background");
        }

        var x = document.getElementsByClassName("ncua-seal");
        if (x.length > 0) {
          x[0].classList.remove("d-none");
        }

        // change favicon and title
        var link = document.querySelector("link[rel~='icon']");
        link.href = "assets/icons/favicon_acet.ico?app=acet1";

        var title = document.querySelector("title");
        title.innerText = "ACET";
      }
      break;
    case "TSA":
      {
        // change favicon and title
        var link = document.querySelector("link[rel~='icon']");
        link.href = "assets/icons/favicon_tsa.ico?app=tsa1";

        var title = document.querySelector("title");
        title.innerText = "CSET-TSA";
      }
      break;
    case "CF":
      {
        // change favicon and title
        var link = document.querySelector("link[rel~='icon']");
        link.href = "assets/icons/favicon_cf.ico?app=cf1";

        var title = document.querySelector("title");
        title.innerText = "CSET-CF";
      }
      break;
    case "RRA":
      {
        // change favicon and title
        var link = document.querySelector("link[rel~='icon']");
        link.href = "assets/icons/favicon_rra.ico?app=rra1";

        var title = document.querySelector("title");
        title.innerText = "CISA - Ransomware Readiness";
      }
      break;
  }
}
