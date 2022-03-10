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
        int AssessmentId { get; set; }

        /// <summary>
        /// The order that the observable occurred.  The order can be
        /// changed in the UI by the user.
        /// </summary>
        int Sequence { get; set; }

        /// <summary>
        /// The permanent unique key for an Observable.  
        /// </summary>
        int ObservableId { get; set; }


        string Title { get; set; }

        string Description { get; set; }

        /// <summary>
        /// TODO: Definitely refactor and rename this.
        /// We want to support a datetime, but we also want
        /// to support a range of time, such as during a shift.  
        /// </summary>
        string WhenThisHappened { get; set; }

        string Reporter { get; set; }

        bool IsFirstTimeSeen { get; set; }
        

        // Categories - TODO:  refactor this to support a larger list
        bool CatPhysical { get; set; }
        bool CatDigital { get; set; }
        bool CatNetwork { get; set; }


        // Questions
        bool IsAffectingOperations { get; set; }
        string AffectingOperationsDesc { get; set; }

        bool IsAffectingProcesses { get; set; }
        string AffectingProcessesDesc { get; set; }

        bool IsMultipleDevices { get; set; }
        string MultipleDevicesDesc { get; set; }

        bool IsMultipleNetworkLayers { get; set; }
        string MultipleNetworkLayersDesc { get; set; }
    }
}
