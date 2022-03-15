using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.CyOTE
{
    /// <summary>
    /// An Observable/Anomaly is an incident of something that
    /// the operator witnessed and reported.
    /// </summary>
    public class Observable
    {
        public int AssessmentId { get; set; }

        /// <summary>
        /// The order that the observable occurred.  The order can be
        /// changed in the UI by the user.
        /// </summary>
        public int Sequence { get; set; }

        /// <summary>
        /// The permanent unique key for an Observable.  
        /// </summary>
        public int ObservableId { get; set; }


        public string Title { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// TODO: Definitely refactor and rename this.
        /// We want to support a datetime, but we also want
        /// to support a range of time, such as during a shift.  
        /// </summary>
        public string WhenThisHappened { get; set; }

        public string Reporter { get; set; }

        public bool IsFirstTimeSeen { get; set; }



        public List<ObservableOption> Options { get; set; } = new List<ObservableOption>();

        public Dictionary<string, object> OptionMap { get; set; } = new Dictionary<string,object>();


        // Categories - TODO:  refactor this to support a larger list
        public bool PhysicalCategory { get; set; }
        public bool DigitalCategory { get; set; }
        public bool NetworkCategory { get; set; }


        // Questions
        public bool IsAffectingOperations { get; set; }
        public string AffectingOperationsText { get; set; }

        public bool IsAffectingProcesses { get; set; }
        public string AffectingProcessesText { get; set; }

        public bool IsMultipleDevices { get; set; }
        public string MultipleDevicesText { get; set; }

        public bool IsMultipleNetworkLayers { get; set; }
        public string MultipleNetworkLayersText { get; set; }
    }
}
