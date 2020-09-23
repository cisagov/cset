import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-mat-cmmc',
  templateUrl: './mat-cmmc.component.html',
  styleUrls: ['./mat-cmmc.component.scss']
})
export class MatCmmcComponent implements OnInit {

  constructor() { }
  maturity = [
    {
      domain: "Access Control (AC)", 
      maxTotal: 28,
      numberPractices: [
        {
          name: "L1",
          answered: 2,
          total: 3, 
          missedQuestions: [
            {
              questionId: 'L1.1.1.1',
              question: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit?'
            }
          ]
        },
        {
          name: "L2",
          answered: 5,
          total: 9, 
          missedQuestions: [
            {
              questionId: 'L2.1.1.1',
              question: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit?'
            },
            {
              questionId: 'L2.1.1.2',
              question: 'Ac felis donec et odio pellentesque diam volutpat?'
            },
            {
              questionId: 'L2.1.1.3',
              question: 'Tortor posuere ac ut consequat semper viverra?'
            },
            {
              questionId: 'L2.1.1.4',
              question: 'Eget nullam non nisi est sit amet facilisis?'
            },
          ]
        },
        {
          name: "L3",
          answered: 9,
          total: 9
        },
        {
          name: "L4",
          answered: 3,
          total: 3
        },
        {
          name: "L5",
          answered: 2,
          total: 2
        },
      ], 
      total: 26
    },
    {
      domain: "Asset Management (AM)",
      maxTotal: 28,
      numberPractices: [
        {
          name: "L3",
          answered: 1,
          total: 1
        },
        {
          name: "L4",
          answered: 1,
          total: 1
        }
      ], 
      total: 2
    },
    {
      domain: "Audit and Accountability (AU)",
      maxTotal: 28,
      numberPractices: [
        {
          name: "L2",
          answered: 4,
          total: 4
        },
        {
          name: "L3",
          answered: 7,
          total: 7
        },
        {
          name: "L4",
          answered: 2,
          total: 2
        },
        {
          name: "L5",
          answered: 1,
          total: 1
        },
      ], 
      total: 14
    }, 
    {
      domain: "Awareness and Training (AT)",
      maxTotal: 28,
      numberPractices: [
        {
          name: "L2",
          answered: 2,
          total: 2
        },
        {
          name: "L3",
          answered: 1,
          total: 1
        },
        {
          name: "L4",
          answered: 2,
          total: 2
        }
      ], 
      total: 5
    },
    {
      domain: "Configuration Managment (CM)",
      maxTotal: 28,
      numberPractices: [
        {
          name: "L2",
          answered: 4,
          total: 6,
          missedQuestions: [
            {
              questionId: 'L2.1.2.1',
              question: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit?'
            },
            {
              questionId: 'L2.1.2.2',
              question: 'Ac felis donec et odio pellentesque diam volutpat?'
            }
          ]
        },
        {
          name: "L3",
          answered: 3,
          total: 3
        },
        {
          name: "L4",
          answered: 1,
          total: 1
        },
        {
          name: "L5",
          answered: 1,
          total: 1
        },
      ], 
      total: 11
    }
  ]
  maxWidth = 800;

  ngOnInit() {
  }

  calcWidth(a, t){
    return (Math.round((a/t) * this.maxWidth));
  }

  getPracticeStyle(name){
    return name.toLowerCase();
    
  }

  checkTotal(a, t){
    return a < t ? 'badge-danger' : 'badge-success';
  }
}
