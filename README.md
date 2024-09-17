
# What is CSET?
The Cybersecurity Infrastructure Security Agency (CISA) and the Idaho National Laboratory (INL) develop the Cyber Security Evaluation Tool (CSET®) for asset owners with the primary objective of reducing the risk to the nation’s critical infrastructure. Control systems are defined as electronic devices that control physical processes and as such, are a crucial element in the protection of our nation’s infrastructure.
 
CSET is a free software tool that guides users through a step-by-step process to collect facility-specific information addressing topics such as hardware, software, administrative policies, and user obligations. It then compares that information to relevant security standards and regulations, assesses overall compliance, and provides appropriate recommendations for improving cybersecurity posture. The tool pulls its recommendations from a collection of the best available cybersecurity standards, guidelines, and practices. Where appropriate, recommendations are linked to a set of actions that can be applied to enhance cybersecurity controls.
 
CSET provides the following:
 
•	A framework for analyzing cybersecurity vulnerabilities associated with an organization’s overall industrial control system (ICS) and information technology (IT) architecture.

•	A consistent and technically sound methodology to identify, analyze, and communicate to security professionals the various vulnerabilities and consequences that may be exploited by cyber means.

•	The means for the user to document a process for identifying cybersecurity vulnerabilities.

•	Suggested methods to evaluate options for improvement based on existing standards and recommended practices.

View the [CSET Overview](https://www.youtube.com/watch?v=B3xAh4iSRO0) and [CSET Detailed Video](https://www.youtube.com/watch?v=ELbvQTl4xmU) to learn more about CSET and how to use the software.

## Download
[CSET Releases](https://github.com/cisagov/cset/releases/)

Local installers ("standalone") are available as well as binaries for creating enterprise installations.

## How to Install and Run CSET/Enterprise

CSET operates on Windows laptops or desktop computers and can also be configured for a client-server architecture.

For more information, see the [CSET Installation Options](install-and-troubleshooting-guides/README.md).

## License

MIT License, Apache License 2.0

Copyright 2018 Battelle Energy Alliance, LLC

See [License.txt](License.txt), and [NOTICE.txt](NOTICE.txt)

Contact information of authors: cset_PMO@cisa.dhs.gov

Idaho National Laboratory:
P.O. Box 1625, MS 3870, Idaho Falls, ID 83415

CISA - NGL Stop 0630
Cybersecurity and Infrastructure Security Agency:

1110 N. Glebe Road
Arlington, VA 20598-0630

[CISAgov Youtube channel](https://www.youtube.com/@CISAgov)

Includes software licensed under LGPL

LGPL dependencies are required to build CSET. You will be required to acquire them via nuGet 
in order to build this software. They are not distributed with this source.

## System Requirements

### System Requirements for Local Installation

It is recommended that users meet the minimum system hardware and software requirements prior to installing CSET. This includes:

• Pentium dual core 2.2 GHz processor (Intel x86 compatible)
• 6 GB free disk space
• 4 GB of RAM
• Microsoft Windows 10 or higher
• Microsoft .NET 7 Runtime (included in CSET installation)
• Microsoft ASP.NET Core 7 Runtime (included in CSET installation)
• Microsoft SQL Server 2022 LocalDB (included in CSET installation)

### System Requirements for Enterprise Installation

It is recommended that users meet the minimum system hardware and software requirements prior to installing CSET. This includes:

• Pentium dual core 2.2 GHz processor (Intel x86 compatible)
• 8 GB free disk space
• 4 GB of RAM
• Microsoft Windows Server 2016 Edition or higher recommended
• Microsoft .NET 7 Runtime
• Microsoft ASP.NET Core 7 Runtime
• Microsoft SQL Server 2022 or higher recommended
• Internet Information Server (IIS) or Kestrel

Other Items of Note:
• For all platforms, it is recommended the user upgrade to the latest Windows Service Pack and install critical updates 
available from the Windows Update web site to ensure the best compatibility and security.

## Questions and Feedback

If you have questions about using CSET, please contact CSET_PMO@cisa.dhs.gov. 

For additional information about CISA, see https://www.cisa.gov/.

To ask questions or request help, propose a feature or module, or report a bug, security vulnerability or unexpected behavior, add a new issue here: https://github.com/cisagov/cset/issues




