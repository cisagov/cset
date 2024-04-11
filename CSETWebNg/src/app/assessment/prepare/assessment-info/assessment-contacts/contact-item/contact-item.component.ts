////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from "@angular/core";
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { AlertComponent } from "../../../../../dialogs/alert/alert.component";
import { EmailComponent } from "../../../../../dialogs/email/email.component";
import { EditableUser } from "../../../../../models/editable-user.model";
import { User } from "../../../../../models/user.model";
import { AssessmentService, Role } from "../../../../../services/assessment.service";
import { AuthenticationService } from "../../../../../services/authentication.service";
import { ConfigService } from "../../../../../services/config.service";
import { EmailService } from "../../../../../services/email.service";
import { LayoutService } from "../../../../../services/layout.service";
import { TranslocoService } from "@ngneat/transloco";

@Component({
  selector: "app-contact-item",
  templateUrl: "./contact-item.component.html",
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ContactItemComponent implements OnInit {
  @Input()
  contact: EditableUser;
  @Input()
  enableMyControls: boolean = true;
  @Input()
  contactsList: EditableUser[];
  @Output()
  add = new EventEmitter<EditableUser>();
  @Output()
  create = new EventEmitter<EditableUser>();
  @Output()
  remove = new EventEmitter<boolean>();
  @Output()
  startEditEvent = new EventEmitter<boolean>();
  @Output()
  abandonEditEvent = new EventEmitter<boolean>();
  @Output()
  edit = new EventEmitter<EditableUser>();

  @ViewChild('topScrollAnchor') topScroll;

  emailDialog: MatDialogRef<EmailComponent>;
  results: EditableUser[];
  roles: Role[];
  editMode: boolean;


  constructor(
    private configSvc: ConfigService,
    private emailSvc: EmailService,
    public auth: AuthenticationService,
    private assessSvc: AssessmentService,
    private dialog: MatDialog,
    public layoutSvc: LayoutService,
    public tSvc: TranslocoService
  ) {
    this.editMode = true;
  }

  ngOnInit() {
    if (this.roles == null) {
      this.assessSvc.refreshRoles().subscribe((response: Role[]) => {
        response.find(x => x.assessmentRoleId == 1).assessmentRole = this.tSvc.translate('contact.participant');
        response.find(x => x.assessmentRoleId == 2).assessmentRole = this.tSvc.translate('contact.facilitator');
        this.assessSvc.roles = response;
        this.roles = response;
        this.contact.roles = response;
      });
    }

    this.roles = this.assessSvc.roles;
    this.contact.roles = this.roles;
    if (this.contact.evaluateCanEdit) {
      this.editMode = this.contact.evaluateCanEdit();
    }
  }

  isEmailValid() {
    // allow blank/null emails as valid
    if (!this.contact.primaryEmail) {
      return true;
    }
    return this.emailSvc.validAddress(this.contact.primaryEmail);
  }

  openEmailDialog() {
    const subject = this.configSvc.config.defaultInviteSubject;
    const body = this.configSvc.config.defaultInviteTemplate;

    this.emailDialog = this.dialog.open(EmailComponent, {
      width: this.layoutSvc.hp ? '90%' : '',
      maxWidth: this.layoutSvc.hp ? '90%' : '',
      data: {
        showContacts: false,
        contacts: [this.contact],
        subject: subject,
        body: body
      }
    });
    this.emailDialog.afterClosed().subscribe(x => {
      this.contact.invited = x[this.contact.primaryEmail];
    });
  }

  search(
    fname: string = this.contact.firstName,
    lname: string = this.contact.lastName,
    email: string = this.contact.primaryEmail,
    poc: boolean = this.contact.isPrimaryPoc,
    siteParticipant: boolean = this.contact.isSiteParticipant,
  ) {
    this.assessSvc
      .searchContacts({
        firstName: fname,
        lastName: lname,
        primaryEmail: email,
        assessmentId: this.assessSvc.id(),
        isPrimaryPoc: poc,
        isSiteParticipant: siteParticipant
      })
      .subscribe((data: User[]) => {
        this.results = [];
        for (const u of data) {
          this.results.push(new EditableUser(u));
        }
      });
  }

  select(result: EditableUser) {
    this.contact.userId = result.userId;
    this.contact.firstName = result.firstName;
    this.contact.lastName = result.lastName;
    this.contact.title = result.title;
    this.contact.phone = result.phone;
    this.contact.primaryEmail = result.primaryEmail;
    this.contact.contactId = result.contactId;
    this.contact.saveEmail = result.primaryEmail;
    this.contact.cellPhone = result.cellPhone;
    this.contact.organizationName = result.organizationName;
    this.contact.siteName = result.siteName;
    this.contact.emergencyCommunicationsProtocol = result.emergencyCommunicationsProtocol;
    this.contact.isPrimaryPoc = result.isPrimaryPoc;
    this.contact.isSiteParticipant = result.isSiteParticipant;
    this.contact.reportsTo = result.reportsTo;
    this.contact.assessmentRoleId = 1;
  }

  changeRole() {
    if (this.contact.saveEmail) {
    } else {
      this.contact.saveEmail = this.contact.primaryEmail;
    }
    this.edit.emit(this.contact);
  }

  saveContact() {
    if (this.contact.isNew) {
      if (this.existsDuplicateEmail(this.contact.primaryEmail)) {
        return;
      }

      this.create.emit(this.contact);

      this.contact.isNew = false;
      this.editMode = true;
    } else {
      this.finishEdit();
    }
    return true;
  }

  removeContact() {
    this.remove.emit(true);
  }

  editContact() {
    this.contact.startEdit();
    this.startEditEvent.emit();
    this.editMode = false;
  }

  existsDuplicateEmail(newEmail: string) {
    if (!newEmail) {
      return false;
    }

    for (const c of this.contactsList.filter(item => item !== this.contact)) {
      if ((newEmail !== null || newEmail !== '') && (c.primaryEmail.toUpperCase() === newEmail.toUpperCase())) {
        this.dialog
          .open(AlertComponent, {
            data: { messageText: "This email has already been used. " }
          })
          .afterClosed()
          .subscribe();
        return true;
      }
    }
    return false;
  }

  finishEdit() {
    if (this.existsDuplicateEmail(this.contact.primaryEmail)) {
      return;
    }

    if (this.isEmailValid()) {
      this.contact.endEdit();
      if (!this.contact.isNew) {
        this.edit.emit(this.contact);
      } else {
        this.saveContact();
      }
      this.editMode = true;
    }
  }

  abandonEdit() {
    this.contact.abandonEdit();
    this.abandonEditEvent.emit();
    this.editMode = true;
    if (this.contact.isNew) {
      this.remove.emit(true);
    }
  }

  showControls() {
    if (this.assessSvc.userRoleId === 2 && !this.contact.isFirst) {
      return true;
    }
    return false;
  }

  getRoleName(roleId: number) {
    return this.roles.find(x => x.assessmentRoleId === roleId).assessmentRole;
  }

  shouldDisablePrimaryPoc() {
    return !!this.contactsList.find(x => x.isPrimaryPoc) && !this.contact.isPrimaryPoc;
  }

  /**
   * Scrolls to the top of this contact item
   */
  scrollToTop() {
    this.topScroll?.nativeElement.scrollIntoView({ behavior: 'smooth', alignToTop: true });
  }
}
