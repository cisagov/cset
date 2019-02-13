//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Data.Entity;
using DataAccess.Model;

namespace DataAccess
{
    public class FileContext : DbContext
    {
        public DbSet<FileDescription> FileDescriptions { get; set; }
    }
}

