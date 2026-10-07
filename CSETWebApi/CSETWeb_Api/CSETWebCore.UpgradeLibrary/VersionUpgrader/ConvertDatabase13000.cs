//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.IO;


namespace UpgradeLibrary.Upgrade
{
    internal class ConvertDatabase13000 : ConvertSqlDatabase
    {
        public ConvertDatabase13000(string path) : base(path)
        {
            myVersion = new Version("13.0.0.0");
        }


        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>F
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12404_to_13000.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12404_to_13000_data.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12404_to_13000_data2.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12404_to_13000_set_local_user_flag.sql"), conn);

                ConvertSectors(conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.4.0.4 to 13.0.0.0: " + e.Message);
            }
        }


        /// <summary>
        /// Move sector and subsector/industry values from DETAILS_DEMOGRAPHICS to ASSESSMENT_SECTOR_SUBSECTOR
        /// </summary>
        private void ConvertSectors(SqlConnection conn)
        {
            List<int> assessmentIds = new List<int>();
            using (SqlCommand cmd = new SqlCommand(
                "SELECT Assessment_Id FROM DETAILS_DEMOGRAPHICS WHERE DataItemName = 'SECTOR'",
                conn))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        assessmentIds.Add((int)reader["Assessment_Id"]);
                    }
                }
            }

            foreach (int assessmentId in assessmentIds)
            {
                ConvertOneAssessment(assessmentId, conn);
            }
        }


        /// <summary>
        /// Moves sector and industry selections from DETAILS_DEMOGRAPHICS to ASSESSMENT_SECTOR_SUBSECTOR.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="conn"></param>
        private void ConvertOneAssessment(int assessmentId, SqlConnection conn)
        {
            // Get sector details
            int? sectorId = null;
            using (SqlCommand cmd = new(
                "SELECT IntValue FROM DETAILS_DEMOGRAPHICS WHERE Assessment_Id = @assessmentId AND DataItemName = 'SECTOR'",
                conn))
            {
                cmd.Parameters.AddWithValue("@assessmentId", assessmentId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    sectorId = (int)result;
                }
            }

            // Get subsector details
            int? subsectorId = null;
            using (SqlCommand cmd = new(
                "SELECT IntValue FROM DETAILS_DEMOGRAPHICS WHERE Assessment_Id = @assessmentId AND DataItemName = 'SUBSECTOR'",
                conn))
            {
                cmd.Parameters.AddWithValue("@assessmentId", assessmentId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    subsectorId = (int)result;
                }
            }

            if (sectorId != null)
            {
                // Insert new ASSESSMENT_SECTOR_SUBSECTOR record
                using (SqlCommand cmd = new(
                    "INSERT INTO ASSESSMENT_SECTOR_SUBSECTOR (Assessment_Id, SectorId, IndustryId, Sequence) VALUES (@assessmentId, @sectorId, @industryId, @sequence)",
                    conn))
                {
                    cmd.Parameters.AddWithValue("@assessmentId", assessmentId);
                    cmd.Parameters.AddWithValue("@sectorId", sectorId);
                    cmd.Parameters.AddWithValue("@industryId", subsectorId ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@sequence", 1);
                    cmd.ExecuteNonQuery();
                }
            }

            // Delete old DETAILS_DEMOGRAPHICS records
            using (SqlCommand cmd = new(
                "DELETE FROM DETAILS_DEMOGRAPHICS WHERE Assessment_Id = @assessmentId AND DataItemName IN ('SECTOR', 'SUBSECTOR')",
                conn))
            {
                cmd.Parameters.AddWithValue("@assessmentId", assessmentId);
                cmd.ExecuteNonQuery();
            }
        }
    }
}