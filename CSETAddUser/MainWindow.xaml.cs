using Microsoft.Data.SqlClient;
using Newtonsoft.Json.Linq;
using System.CommandLine;
using System.Data;
using System.IO;
using System.Windows;
using System.Windows.Input;

namespace CSETAddUser
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private ICommand someCommand;
        public ICommand SomeCommand
        {
            get
            {
                return someCommand
                    ?? (someCommand = new ActionCommand(() =>
                    {
                        SetupAdd();
                    }));
            }
        }


        /// <summary>
        /// Use for commandline execution
        /// </summary>
        /// <param name="args"></param>
        public static async Task MainSub(string[] args)
        {
            var fnameOption = new Option<string>("--fname", "-f") { Description = "the first name" };
            var lnameOption = new Option<string>("--lname", "-l") { Description = "the last name" };
            var emailOption = new Option<string>("--email", "-e") { Description = "the email address" };

            var rootCommand = new RootCommand("Add CSET User");
            rootCommand.Options.Add(fnameOption);
            rootCommand.Options.Add(lnameOption);
            rootCommand.Options.Add(emailOption);

            rootCommand.SetAction(parseResult =>
            {
                string? fname = parseResult.GetValue(fnameOption);
                string? lname = parseResult.GetValue(lnameOption);
                string? email = parseResult.GetValue(emailOption);

                if (string.IsNullOrEmpty(fname) || string.IsNullOrEmpty(lname) || string.IsNullOrEmpty(email))
                {
                    Console.WriteLine("First Name, Last Name, and Email are required. Try adduser --help for details.");
                    return;
                }

                string pass1;
                string pass2;
                do
                {
                    Console.Write("Enter Password:");
                    pass1 = GetPassword();
                    Console.WriteLine();
                    Console.Write("Confirm Password:");
                    pass2 = GetPassword();
                    if (pass1 != pass2)
                        Console.WriteLine("Password did not match");
                }
                while (pass1 != pass2);

                AddUser(new USER()
                {
                    FirstName = fname,
                    LastName = lname,
                    PrimaryEmail = email,
                    Password = pass1
                });
            });

            await rootCommand.Parse(args).InvokeAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        private static void AddUser(USER user)
        {
            string currDirectory = Directory.GetCurrentDirectory();
            string appSettingsPath = currDirectory + "\\appsettings.json";

            JObject document = JObject.Parse(System.IO.File.ReadAllText(appSettingsPath));
            JToken element = document["ConnectionStrings"];

            string connectionString = element["CSET_DB"].ToString();


            new CreateUser().EncryptPassword(user);

            using (SqlConnection sqlConnection = new SqlConnection(connectionString))
            {
                try
                {
                    SqlCommand sqlCommand = new SqlCommand();
                    sqlCommand.CommandType = CommandType.Text;
                    sqlCommand.CommandText = "SELECT * FROM USERS WHERE PrimaryEmail = @PrimaryEmail";
                    sqlCommand.Parameters.AddWithValue("@PrimaryEmail", user.PrimaryEmail);
                    sqlCommand.Connection = sqlConnection;
                    sqlConnection.Open();
                    SqlDataReader sqlDataReader = sqlCommand.ExecuteReader();

                    if (sqlDataReader.Read())
                    {
                        sqlDataReader.Close();
                        sqlCommand.CommandText = "UPDATE USERS SET Password=@Password, Salt=@Salt, FirstName=@FirstName, LastName=@LastName WHERE PrimaryEmail=@PrimaryEmail";
                        sqlCommand.Parameters.Clear();
                        sqlCommand.Parameters.AddWithValue("@Password", user.Password);
                        sqlCommand.Parameters.AddWithValue("@Salt", user.Salt);
                        sqlCommand.Parameters.AddWithValue("@FirstName", user.FirstName);
                        sqlCommand.Parameters.AddWithValue("@LastName", user.LastName);
                        sqlCommand.Parameters.AddWithValue("@PrimaryEmail", user.PrimaryEmail);
                        sqlCommand.ExecuteNonQuery();
                    }
                    else
                    {
                        sqlDataReader.Close();
                        sqlCommand.CommandText = "INSERT INTO USERS (PrimaryEmail, Password, Salt, IsSuperUser, PasswordResetRequired, FirstName, LastName, Id) VALUES (@PrimaryEmail, @Password, @Salt, 0, 0, @FirstName, @LastName, NULL)";
                        sqlCommand.Parameters.Clear();
                        sqlCommand.Parameters.AddWithValue("@PrimaryEmail", user.PrimaryEmail);
                        sqlCommand.Parameters.AddWithValue("@Password", user.Password);
                        sqlCommand.Parameters.AddWithValue("@Salt", user.Salt);
                        sqlCommand.Parameters.AddWithValue("@FirstName", user.FirstName);
                        sqlCommand.Parameters.AddWithValue("@LastName", user.LastName);
                        sqlCommand.ExecuteNonQuery();
                    }

                    sqlCommand.CommandText = "SELECT * FROM USERS WHERE PrimaryEmail = @PrimaryEmail";
                    sqlCommand.Parameters.Clear();
                    sqlCommand.Parameters.AddWithValue("@PrimaryEmail", user.PrimaryEmail);
                    sqlDataReader = sqlCommand.ExecuteReader();
                    if (sqlDataReader.Read())
                    {
                        int userId = (int)sqlDataReader["UserId"];
                        sqlDataReader.Close();
                        sqlCommand.CommandText = "INSERT INTO PASSWORD_HISTORY (UserId, Created, Password, Salt, Is_Temp) VALUES (@UserId, @Created, @Password, @Salt, 0)";
                        sqlCommand.Parameters.Clear();
                        sqlCommand.Parameters.AddWithValue("@UserId", userId);
                        sqlCommand.Parameters.AddWithValue("@Created", DateTime.UtcNow);
                        sqlCommand.Parameters.AddWithValue("@Password", user.Password);
                        sqlCommand.Parameters.AddWithValue("@Salt", user.Salt);
                        sqlCommand.ExecuteNonQuery();
                    }
                }
                catch (SqlException sqle)
                {
                    throw;
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private static string GetPassword()
        {
            string str = "";
            ConsoleKeyInfo consoleKeyInfo;
            do
            {
                consoleKeyInfo = Console.ReadKey(true);
                if (consoleKeyInfo.Key != ConsoleKey.Backspace && consoleKeyInfo.Key != ConsoleKey.Enter)
                {
                    str += consoleKeyInfo.KeyChar.ToString();
                    Console.Write("*");
                }
                else if (consoleKeyInfo.Key == ConsoleKey.Backspace && str.Length > 0)
                {
                    str = str.Substring(0, str.Length - 1);
                    Console.Write("\b \b");
                }
            }
            while (consoleKeyInfo.Key != ConsoleKey.Enter);
            return str;
        }


        /// <summary>
        /// 
        /// </summary>
        private void SetupAdd()
        {
            this.Warning.Foreground = System.Windows.Media.Brushes.Red;
            this.Warning.Visibility = Visibility.Hidden;
            if ((Password1.Password != Password2.Password) || string.IsNullOrWhiteSpace(Password1.Password))
            {
                Warning.Visibility = Visibility.Visible;
                return;
            }

            AddUser(new USER()
            {
                FirstName = txtFirstName.Text,
                LastName = txtLastName.Text,
                PrimaryEmail = txtEmail.Text,
                Password = Password1.Password
            });
            this.Warning.Content = "Added Successfully";
            this.Warning.Visibility = Visibility.Visible;
            this.Warning.Foreground = System.Windows.Media.Brushes.Green;
        }


        /// <summary>
        /// 
        /// </summary>
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SetupAdd();
            }
            catch (Exception ex)
            {
                System.Windows.MessageBox.Show(ex.Message);
                File.WriteAllText("AddUserLog.txt", ex.StackTrace);
            }
        }
    }

    public class ActionCommand : ICommand
    {
        private readonly Action _action;

        public ActionCommand(Action action)
        {
            _action = action;
        }

        public void Execute(object? parameter)
        {
            _action();
        }

        public bool CanExecute(object? parameter)
        {
            return true;
        }

        public event EventHandler CanExecuteChanged;
    }
}

