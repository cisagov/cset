namespace CSETWebCore.Model.Question
{
    public class FindingContact
    {
        public int Finding_Id { get; set; }
        public int Assessment_Contact_Id { get; set; }

        /// <summary>
        /// this is custom binding that had both the primaryemail@d.com -- FirstName, LastName
        /// </summary>        
        public string Name { get; set; }
        public bool Selected { get; set; }
    }
}