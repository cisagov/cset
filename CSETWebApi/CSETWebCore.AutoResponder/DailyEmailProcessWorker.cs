using CSETWebCore.DataLayer.Model;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.AutoResponder
{
    public class DailyEmailProcessWorker
    {
        private readonly IConfiguration configuration;
        private readonly CSETContext _context;
        private readonly IEmailHelper _emailHelper;

        public DailyEmailProcessWorker(IConfiguration configuration, CSETContext context, IEmailHelper emailHelper)
        {
            this.configuration = configuration;
            this._context = context;
            this._emailHelper = emailHelper;
            this.NowDate = DateTime.Now;
        }


        /// <summary>
        /// Value to use for now.   
        /// changeable for testing harness
        /// </summary>
        public DateTime NowDate { get; set; }


        public void ProcessEmails()
        {
            var userlist = from u in _context.USERS                           
                           where u.EmailSentCount < 5 && u.PrimaryEmail != null
                           select u;
            
            var emailHistory = (from h in _context.USER_EMAIL_HISTORY
                               group h by h.UserId into g                               
                               select new { userid = g.Key, LastSentDate = g.Max(s => s.EmailSentDate) }
                               ).ToDictionary(x=> x.userid,y=> y.LastSentDate);


            foreach (var user in userlist.ToList())
            {
                if (IsValidEmail(user.PrimaryEmail)){
                    switch (user.EmailSentCount)
                    {
                        case 0:
                            //first email sent it and 
                            _emailHelper.SendFollowUp(user.PrimaryEmail, user.FirstName, user.LastName);
                            UpdateRecords(user);
                            break;
                        case 1:
                            //look to see if it has been a week since the last send date
                            //if it has then send it and update record
                            checkEmailSend(user, emailHistory, 1);
                            break;
                        case 2:
                            checkEmailSend(user, emailHistory, 3);
                            break;
                        case 3:
                            checkEmailSend(user, emailHistory, 6);
                            break;
                        case 4:
                            checkEmailSend(user, emailHistory, 10);
                            break;
                        default:
                            //skip it 
                            break;

                    }
                }
            }
        }

        private void checkEmailSend(USERS user, Dictionary<int,DateTime> emailHistory, int weekCheck)
        {
            DateTime lastSent;
            if (emailHistory.TryGetValue(user.UserId, out lastSent))
            {
                if (AtleastAWeekHasPassed(lastSent, weekCheck))
                {
                    _emailHelper.SendFollowUp(user.PrimaryEmail, user.FirstName, user.LastName);
                    UpdateRecords(user);
                }
            }

        }


        private static bool IsValidEmail(string email)
        {
            var valid = true;

            try
            {
                var emailAddress = new MailAddress(email);
            }
            catch
            {
                valid = false;
            }

            return valid;
        }

        bool IsWeekDay()
        {
            var day = this.NowDate.DayOfWeek;
            return !((day == DayOfWeek.Saturday) || (day == DayOfWeek.Sunday));
        }

        private bool AtleastAWeekHasPassed(DateTime StartDate, int weekspassed)
        {
            DateTime EndDate = this.NowDate;
            return (EndDate - StartDate).TotalDays >= 7*weekspassed;
        }


        private void UpdateRecords(USERS u)
        {
            try
            {
                u.EmailSentCount++;
                _context.USER_EMAIL_HISTORY.Add(new USER_EMAIL_HISTORY()
                {
                    UserId = u.UserId,
                    EmailSentDate = this.NowDate
                });
                _context.SaveChanges();
            }catch(Exception exc)
            {   
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
            }
        }
    }
}
