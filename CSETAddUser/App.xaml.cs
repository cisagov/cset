using System;
using System.Windows;

namespace CSETAddUser
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : System.Windows.Application
    {
        protected override async void OnStartup(StartupEventArgs e)
        {
            if (e.Args.Length > 0)
            {
                // Command line mode — don't show UI
                await CSETAddUser.MainWindow.MainSub(e.Args);
                Shutdown();
            }
            else
            {
                // No args — launch the UI normally
                base.OnStartup(e);
                new MainWindow().Show();
            }
        }
    }
}