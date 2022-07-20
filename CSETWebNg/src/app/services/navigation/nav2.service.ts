import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../assessment.service';
import { ConfigService } from '../config.service';

@Injectable({
  providedIn: 'root'
})
export class Nav2Service {

  workflow = [];


  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private router: Router
  ) { }


  /**
   *
   * @param cur
   */
   navNext(cur: string) {
    // find current page
    const currentPageIndex = this.workflow.findIndex(p => p.pageId === cur);

    if (currentPageIndex < 0) {
      return;
    }

    if (currentPageIndex === this.workflow.length - 1) {
      // we are at the last page, nothing to do
      return;
    }

    let newPageIndex = currentPageIndex;
    let showPage = false;

    // skip over any entries without a path or have children or that fail the 'showpage' condition
    do {
      newPageIndex++;
      showPage = this.shouldIShow(this.pages[newPageIndex].condition);
    }
    while (!this.pages[newPageIndex].hasOwnProperty('path')
      || (newPageIndex < this.pages.length && !showPage));


    this.setCurrentPage(this.pages[newPageIndex].pageId);

    const newPath = this.pages[newPageIndex].path.replace('{:id}', this.assessSvc.id().toString());
    this.router.navigate([newPath]);
  }


  /**
   * The workflow in force for a "standard" assessment.
   */
  workflowClassic = [
    // Prepare Phase
    {
      displayText: 'Prepare', pageId: 'phase-prepare', children: [
        { displayText: 'Assessment Configuration', pageId: 'info1', path: 'assessment/{:id}/prepare/info1' },
        { displayText: 'Assessment Information', pageId: 'info2', path: 'assessment/{:id}/prepare/info2' },
        {
          displayText: 'Security Assurance Level (SAL)',
          pageId: 'sal', level: 1,
          path: 'assessment/{:id}/prepare/sal'
        },
      ]
    },

    // Assessment Phase
    {
      displayText: 'Assessment', children: [
        {
          displayText: 'Standard Questions',
          pageId: 'questions',
          path: 'assessment/{:id}/questions'
        }
      ]
    },

    {
      displayText: 'Results', children: [
        {
          displayText: 'Analysis Dashboard', pageId: 'dashboard', path: 'assessment/{:id}/results/dashboard'
        }
      ]
    }
  ];


  /**
   * The workflow in force for a "maturity" assessment.
   */
  workflowMaturity = [
    // Prepare Phase
    {
      displayText: 'Prepare', pageId: 'phase-prepare', children: [
        { displayText: 'Assessment Configuration', pageId: 'info1', path: 'assessment/{:id}/prepare/info1' },
        { displayText: 'Assessment Information', pageId: 'info2', path: 'assessment/{:id}/prepare/info2' },

        // maturity model tutorials
        {
          displayText: 'CMMC Tutorial',
          pageId: 'tutorial-cmmc', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-cmmc',
          condition: 'MATURITY-CMMC'
        },
        {
          displayText: 'CMMC Tutorial',
          pageId: 'tutorial-cmmc2', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-cmmc2',
          condition: 'MATURITY-CMMC2'
        },
        {
          displayText: 'EDM Tutorial',
          pageId: 'tutorial-edm', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-edm',
          condition: 'MATURITY-EDM'
        },
        {
          displayText: 'CRR Tutorial',
          pageId: 'tutorial-crr', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-crr',
          condition: 'MATURITY-CRR'
        },
        {
          displayText: 'Ransomware Readiness Tutorial',
          pageId: 'tutorial-rra', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-rra',
          condition: 'MATURITY-RRA'
        },
        {
          displayText: 'CIS Tutorial',
          pageId: 'tutorial-cis', level: 1,
          path: 'assessment/{:id}/prepare/tutorial-cis',
          condition: 'MATURITY-CIS'
        },
        {
          displayText: 'CIS Configuration',
          pageId: 'config-cis', level: 1,
          path: 'assessment/{:id}/prepare/config-cis',
          condition: 'MATURITY-CIS'
        },
      ]
    },

    // Assessment Phase
    {
      displayText: 'Assessment', children: [

      ]
    },




    {
      displayText: 'Critical Service Information',
      pageId: 'csi', level: 1,
      path: 'assessment/{:id}/prepare/csi',
      condition: 'MATURITY-CIS'
    },

    {
      displayText: 'CMMC Target Level Selection', pageId: 'cmmc-levels', level: 1,
      path: 'assessment/{:id}/prepare/cmmc-levels',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && (this.assessSvc.usesMaturityModel('CMMC') || this.assessSvc.usesMaturityModel('CMMC2'));
      }
    },





    {
      displayText: 'Cybersecurity Standards Selection',
      pageId: 'standards', level: 1,
      path: 'assessment/{:id}/prepare/standards',
      condition: () => { return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard }
    },

    {
      displayText: 'Cybersecurity Framework',
      pageId: 'framework', level: 1,
      path: 'assessment/{:id}/prepare/framework',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useStandard
          && this.assessSvc.usesStandard('NCSF_V1');
      }
    },

    {
      displayText: 'Standards Specific Screen(s)', level: 1,
      condition: () => { return false; }
    },



    // ACET-specific screens
    {
      displayText: 'Document Request List', pageId: 'acet-drl', level: 1,
      path: 'assessment/{:id}/prepare/required',
      condition: () => { return false; }
    },
    {
      displayText: 'Inherent Risk Profiles', pageId: 'irp', level: 1,
      path: 'assessment/{:id}/prepare/irp',
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'Inherent Risk Profile Summary', pageId: 'irp-summary', level: 1,
      path: 'assessment/{:id}/prepare/irp-summary',
      condition: 'MATURITY-ACET'
    },






    // Questions/Requirements/Statements
    { displayText: 'Assessment', pageId: 'phase-assessment', level: 0 },

    {
      comment: 'This screen displays if no features are selected',
      displayText: 'Assessment Questions',
      pageId: 'placeholder-questions',
      path: 'assessment/{:id}/placeholder-questions',
      level: 1,
      condition: () => {
        return !(this.assessSvc.assessment?.useMaturity
          || this.assessSvc.assessment?.useDiagram
          || this.assessSvc.assessment?.useStandard);
      }
    },

    {
      displayText: 'Maturity Questions',
      pageId: 'maturity-questions',
      path: 'assessment/{:id}/maturity-questions',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('*')
          && !this.assessSvc.usesMaturityModel('CIS')
          && !(this.configSvc.installationMode === 'ACET'
            && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'Statements',
      pageId: 'maturity-questions-acet',
      path: 'assessment/{:id}/maturity-questions-acet',
      level: 1,
      condition: () => {
        return this.assessSvc.assessment?.useMaturity
          && (this.configSvc.installationMode === 'ACET'
            && this.assessSvc.usesMaturityModel('ACET'));
      }
    },

    {
      displayText: 'CIS Questions',
      pageId: 'maturity-questions-nested',
      level: 1,
      condition: 'MATURITY-CIS'
    },

    // CIS nodes are inserted here

    {
      displayText: 'Standard Questions',
      pageId: 'questions',
      path: 'assessment/{:id}/questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    {
      displayText: 'Diagram Component Questions',
      pageId: 'diagram-questions',
      path: 'assessment/{:id}/diagram-questions',
      level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },

    { displayText: 'Results', pageId: 'phase-results', level: 0 },



    // Results - CMMC
    {
      displayText: 'CMMC Results', pageId: 'cmmc-results-node', level: 1,
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Target and Achieved Levels', pageId: 'cmmc-level-results', level: 2, path: 'assessment/{:id}/results/cmmc-level-results',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Level Drill Down', pageId: 'cmmc-level-drilldown', level: 2, path: 'assessment/{:id}/results/cmmc-level-drilldown',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Compliance Score', pageId: 'cmmc-compliance', level: 2, path: 'assessment/{:id}/results/cmmc-compliance',
      condition: 'MATURITY-CMMC'
    },
    {
      displayText: 'Detailed Gaps List', pageId: 'cmmc-gaps', level: 2, path: 'assessment/{:id}/results/cmmc-gaps',
      condition: 'MATURITY-CMMC'
    },

    // Results - CMMC2
    {
      displayText: 'CMMC 2.0 Results', pageId: 'cmmc2-results-node', level: 1,
      condition: 'MATURITY-CMMC2'
    },

    {
      displayText: 'Performance by Level', pageId: 'cmmc2-level-results', level: 2, path: 'assessment/{:id}/results/cmmc2-level-results',
      condition: 'MATURITY-CMMC2'
    },
    {
      displayText: 'Performance by Domain', pageId: 'cmmc2-domain-results', level: 2, path: 'assessment/{:id}/results/cmmc2-domain-results',
      condition: 'MATURITY-CMMC2'
    },
    {
      displayText: 'SPRS Score', pageId: 'sprs-score', level: 2, path: 'assessment/{:id}/results/sprs-score',
      condition: () => {
        return !!this.assessSvc.assessment
          && this.assessSvc.assessment?.useMaturity
          && this.assessSvc.usesMaturityModel('CMMC2')
          && this.assessSvc.assessment.maturityModel.maturityTargetLevel > 1
      }
    },

    //Results - EDM
    {
      displayText: 'EDM Results', pageId: 'edm-results-node', level: 1,
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Summary Results', pageId: 'summary-results', level: 2, path: 'assessment/{:id}/results/summary-results',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Relationship Formation', pageId: 'relationship-formation', level: 2, path: 'assessment/{:id}/results/relationship-formation',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Relationship Management and Governance', pageId: 'relationship-management', level: 2, path: 'assessment/{:id}/results/relationship-management',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Service Protection and Sustainment', pageId: 'service-protection', level: 2, path: 'assessment/{:id}/results/service-protection',
      condition: 'MATURITY-EDM'
    },
    {
      displayText: 'Maturity Indicator Levels', pageId: 'maturity-indicator-levels', level: 2, path: 'assessment/{:id}/results/maturity-indicator-levels',
      condition: 'MATURITY-EDM'
    },

    // Results - CRR
    {
      displayText: 'CRR Results', pageId: 'crr-results-node', level: 1,
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Summary Results', pageId: 'crr-summary-results', level: 2, path: 'assessment/{:id}/results/crr-summary-results',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Asset Management', pageId: 'crr-domain-am', level: 2, path: 'assessment/{:id}/results/crr-domain-am',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Controls Management', pageId: 'crr-domain-cm', level: 2, path: 'assessment/{:id}/results/crr-domain-cm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Configuration and Change Management', pageId: 'crr-domain-ccm', level: 2, path: 'assessment/{:id}/results/crr-domain-ccm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Vulnerability Management', pageId: 'crr-domain-vm', level: 2, path: 'assessment/{:id}/results/crr-domain-vm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Incident Management', pageId: 'crr-domain-im', level: 2, path: 'assessment/{:id}/results/crr-domain-im',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Service Continuity Management', pageId: 'crr-domain-scm', level: 2, path: 'assessment/{:id}/results/crr-domain-scm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Risk Management', pageId: 'crr-domain-rm', level: 2, path: 'assessment/{:id}/results/crr-domain-rm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'External Dependencies Management', pageId: 'crr-domain-edm', level: 2, path: 'assessment/{:id}/results/crr-domain-edm',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Training and Awareness', pageId: 'crr-domain-ta', level: 2, path: 'assessment/{:id}/results/crr-domain-ta',
      condition: 'MATURITY-CRR'
    },
    {
      displayText: 'Situational Awareness', pageId: 'crr-domain-sa', level: 2, path: 'assessment/{:id}/results/crr-domain-sa',
      condition: 'MATURITY-CRR'
    },



    // Results - RRA
    {
      displayText: 'RRA Results', pageId: 'rra-results-node', level: 1,
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Goal Performance', pageId: 'rra-gaps', level: 2, path: 'assessment/{:id}/results/rra-gaps',
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Assessment Tiers', pageId: 'rra-level-results', level: 2, path: 'assessment/{:id}/results/rra-level-results',
      condition: 'MATURITY-RRA'
    },
    {
      displayText: 'Performance Summary', pageId: 'rra-summary-all', level: 2, path: 'assessment/{:id}/results/rra-summary-all',
      condition: 'MATURITY-RRA'
    },



    // Results - Standards
    {
      displayText: 'Standards Results', pageId: 'standards-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },



    {
      displayText: 'Control Priorities', pageId: 'ranked-questions', level: 2, path: 'assessment/{:id}/results/ranked-questions',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Standards Summary', pageId: 'standards-summary', level: 2, path: 'assessment/{:id}/results/standards-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Ranked Categories', pageId: 'standards-ranked', level: 2, path: 'assessment/{:id}/results/standards-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },
    {
      displayText: 'Results By Category', pageId: 'standards-results', level: 2, path: 'assessment/{:id}/results/standards-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useStandard;
      }
    },

    // Results - Components
    {
      displayText: 'Components Results', pageId: 'components-results-node', level: 1,
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Components Summary', pageId: 'components-summary', level: 2, path: 'assessment/{:id}/results/components-summary',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Ranked Components By Category', pageId: 'components-ranked', level: 2, path: 'assessment/{:id}/results/components-ranked',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Component Results By Category', pageId: 'components-results', level: 2, path: 'assessment/{:id}/results/components-results',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Answers By Component Type', pageId: 'components-types', level: 2, path: 'assessment/{:id}/results/components-types',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },
    {
      displayText: 'Network Warnings', pageId: 'components-warnings', level: 2, path: 'assessment/{:id}/results/components-warnings',
      condition: () => {
        return !!this.assessSvc.assessment && this.assessSvc.assessment?.useDiagram;
      }
    },

    // ACET results pages
    {
      displayText: 'ACET Results', pageId: 'acet-results-node', level: 1,
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'ACET Maturity Results', pageId: 'acet-maturity', level: 2, path: 'assessment/{:id}/results/acet-maturity',
      condition: 'MATURITY-ACET'
    },
    {
      displayText: 'ACET Dashboard', pageId: 'acet-dashboard', level: 2, path: 'assessment/{:id}/results/acet-dashboard',
      condition: 'MATURITY-ACET'
    },

    // CIS results pages
    {
      displayText: 'CIS Results', pageId: 'cis-results-node', level: 1,
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'CIS Section Scoring', pageId: 'section-scoring', level: 2, path: 'assessment/{:id}/results/section-scoring',
      condition: 'MATURITY-CIS'
    },
    {
      displayText: 'CIS Deficiencies', pageId: 'ranked-deficiency', level: 2, path: 'assessment/{:id}/results/ranked-deficiency',
      condition: 'MATURITY-CIS'
    },



    {
      displayText: 'High-Level Assessment Description, Executive Summary & Comments', pageId: 'overview', level: 1, path: 'assessment/{:id}/results/overview',
      condition: () => {
        return this.showExecSummaryPage();
      }
    },
    { displayText: 'Reports', pageId: 'reports', level: 1, path: 'assessment/{:id}/results/reports' },
    {
      displayText: 'Feedback', pageId: 'feedback', level: 1, path: 'assessment/{:id}/results/feedback',
      condition: () => {
        return this.configSvc.installationMode !== 'ACET';
      }
    },
    {
      displayText: 'Share Assessment With CISA', pageId: 'analytics', level: 1, path: 'assessment/{:id}/results/analytics',
      condition: () => {
        return false;
        return this.analyticsIsUp() && this.configSvc.installationMode !== 'ACET';
      }
    }

  ];


  /**
   * The workflow in force for a Diagram assessment 
   */
  workflowDiagram = [
    // Prepare Phase
    {
      displayText: 'Prepare', pageId: 'phase-prepare', children: [
        { displayText: 'Assessment Configuration', pageId: 'info1', path: 'assessment/{:id}/prepare/info1' },
        { displayText: 'Assessment Information', pageId: 'info2', path: 'assessment/{:id}/prepare/info2' },
        {
          displayText: 'Security Assurance Level (SAL)',
          pageId: 'sal', level: 1,
          path: 'assessment/{:id}/prepare/sal'
        },
      ]
    },

    //  Diagram
    {
      displayText: 'Network Diagram',
      pageId: 'diagram', level: 1,
      path: 'assessment/{:id}/prepare/diagram/info'
    },
  ];



  /**
   * 
   */
  showExecSummaryPage() : boolean {
    let assessment = this.assessSvc.assessment;
    return assessment?.useDiagram || assessment?.useStandard;
  }

  /**
   * 
   */
  analyticsIsUp() : boolean {
    return false;
  }
}
