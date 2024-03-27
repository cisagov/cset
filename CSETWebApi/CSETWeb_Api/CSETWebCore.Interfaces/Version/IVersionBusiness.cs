using System;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Interfaces.Version
{
    public interface  IVersionBusiness
	{
        CSET_VERSION getversionNumber();
        void getVersion(CSET_VERSION version);
    }
}

