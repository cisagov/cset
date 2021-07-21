using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUtilities
    {
        int UnixTime();
        DateTime UtcToLocal(DateTime dt);
        DateTime LocalToUtc(DateTime dt);
        string GetClientHost();
    }
}
