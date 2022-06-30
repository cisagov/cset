using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer.Model
{
    [Keyless]
    public partial class Answer_Components_Default : Answer_Components_Base
    {
        [StringLength(2048)]
        [Unicode(false)]
        public string FeedBack { get; set; }
        public int Component_Symbol_id { get; set; }
    }
}