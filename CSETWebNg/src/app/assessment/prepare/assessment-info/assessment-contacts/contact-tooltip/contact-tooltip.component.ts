import { Component, Input, OnInit } from '@angular/core';

@Component({
    selector: 'app-contact-tooltip',
    templateUrl: './contact-tooltip.component.html',
    styleUrls: ['./contact-tooltip.component.scss'],
    standalone: false
})
export class ContactTooltipComponent {
  @Input() firstName: string;
  @Input() lastName: string;
  @Input() email: string;
  @Input() phone: string;
  @Input() assessmentRoleId: number;
  @Input() assessmentRole: string;
  @Input() title: string; 
  @Input() organizationName: string; 
  @Input() siteName: string; 
  @Input() cell: string;
  @Input() ecp: string;
  @Input() POC: boolean;
}

