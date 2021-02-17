//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Common;
using CSET_Main.Data;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.POCO
{
    public class ParameterContainer:IParameterContainer
    {
        protected vParameter parameter { get; set; }
        protected PARAMETER_VALUES value { get; set; }
        public int Id { get
            {
                return parameter.Parameter_ID;
            }
        }
        public string Value
        {
            get
            {
                return value.Parameter_Value;
            }
            set
            {
                this.value.Parameter_Value = value;
                if (string.IsNullOrEmpty(value))
                {
                    Task.Delay(5).ContinueWith(_ =>
                    { if (Value == value) { ResetValue(); } });
                }
                else if (Value!= this.parameter.Default_Value)
                {
                    IsExplicitlySet = true;
                }
            }
        }
        public string Default
        {
            get
            {
                return parameter.Default_Value;
            }
        }
        public int Answer_Id
        {
            get
            {
                return value.Answer_Id;
            }
        }
        public string Name
        {
            get { return parameter.Parameter_Name; }
        }
        public bool IsExplicitlySet
        {
            get
            {
                return !value.Parameter_Is_Default; // parameterValue.Parameter_Is_Explicit
            }
            set
            {
                this.value.Parameter_Is_Default = !value;
                if (value == false)
                {
                    this.Value = this.Default;
                }                
            }
        }

        
        public void ResetValue()
        {
            IsExplicitlySet = false;
        }
        public ParameterContainer() { }
        public ParameterContainer(vParameter parameter, PARAMETER_VALUES value)
        {
            this.parameter = parameter;
            this.value = value;
        }

    }
}


