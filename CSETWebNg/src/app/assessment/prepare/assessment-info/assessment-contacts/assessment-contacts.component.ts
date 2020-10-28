////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, OnInit, ViewChildren, Output, EventEmitter } from "@angular/core";
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { AlertComponent } from "../../../../dialogs/alert/alert.component";
import { ConfirmComponent } from "../../../../dialogs/confirm/confirm.component";
import { EmailComponent } from "../../../../dialogs/email/email.component";
import { AssessmentContactsResponse } from "../../../../models/assessment-info.model";
import { User } from "../../../../models/user.model";
import { AssessmentService } from "../../../../services/assessment.service";
import { AuthenticationService } from "../../../../services/authentication.service";
import { ConfigService } from "../../../../services/config.service";
import { EmailService } from "../../../../services/email.service";
import { EditableUser } from "../../../../models/editable-user.model";
import { ContactItemComponent } from "./contact-item/contact-item.component";

@Component({
  selector: "app-assessment-contacts",
  templateUrl: "./assessment-contacts.component.html",
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentContactsComponent implements OnInit {
  @Output() triggerChange = new EventEmitter();

  contacts: EditableUser[] = [];
  emailDialog: MatDialogRef<EmailComponent>;
  userRole: any;
  userEmail: string;
  adding: boolean = false;

  // all child contact item components
  @ViewChildren(ContactItemComponent) contactItems: ContactItemComponent[];


  constructor(
    private configSvc: ConfigService,
    private assessSvc: AssessmentService,
    private emailSvc: EmailService,
    private auth: AuthenticationService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    if (this.assessSvc.id()) {
      this.assessSvc
        .getAssessmentContacts()
        .then((data: AssessmentContactsResponse) => {
          for (const c of data.ContactList) {
            this.contacts.push(new EditableUser(c));
          }
          // this.contacts = data.ContactList;
          this.userRole = data.CurrentUserRole;
          this.userEmail = this.auth.email();
          this.moveUser();
        });
    }
  }

  changeOccurred() {
    this.triggerChange.next();
  }

  moveUser() {
    // move the user's contact to the top of the list
    const myIndex = this.contacts.findIndex(
      contact => contact.PrimaryEmail.toUpperCase() === this.auth.email().toUpperCase()
    );
    this.contacts.unshift(this.contacts.splice(myIndex, 1)[0]);
    this.contacts[0].IsFirst = true;
  }

  hasNewContact() {
    if (this.contacts && this.contacts.length >= 1) {
      return !this.contacts[this.contacts.length - 1].UserId;
    }
    return false;
  }

  /**
   * User just clicked 'add contact'
   */
  newContact() {
    this.adding = true;

    // disable the existing contacts' controls while in add/edit mode
    this.contactItems.forEach(x => x.enableMyControls = false);

    this.contacts.push(
      new EditableUser({
        AssessmentRoleId: 1
      })
    );
  }

  /**
   * User just clicked 'Save' in the add/edit dialog area
   */
  createContact(contact: EditableUser) {
    this.contacts[this.contacts.length - 1] = contact;

    this.assessSvc.createContact(contact).subscribe(
      (response: { ContactList: User[] }) => {
        contact.ContactId = response.ContactList[0].ContactId;
        contact.UserId = response.ContactList[0].UserId;
        this.changeOccurred();
      },
      error => {
        this.dialog
          .open(AlertComponent, {
            data: "Error adding assessment contact: " + error
          })
          .afterClosed()
          .subscribe();
        console.log(
          "Error adding assessment contact: " + JSON.stringify(contact)
        );
      }
    );
    this.adding = false;

    // done adding - show the contacts' controls
    this.contactItems.forEach(x => x.enableMyControls = true);
  }

  /**
   * This fires when the user clicks the trashcan icon of an existing contact
   * or cancels out of the add dialog.
   */
  removeContact(contact: EditableUser, indx: number) {
    this.contactItems.forEach(x => x.enableMyControls = true);

    if (this.adding && contact.IsNew) {
      this.contacts.splice(indx, 1);
      this.adding = false;
      this.changeOccurred();
      return;
    }
    this.adding = false;
    if (contact.FirstName === undefined
      || contact.LastName === undefined
      || contact.PrimaryEmail === undefined
    ) {
      this.dropContact(contact);
      this.changeOccurred();
      return;
    }

    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to remove " +
      contact.FirstName +
      " " +
      contact.LastName +
      " from this assessment?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropContact(contact);
        this.changeOccurred();
      }
    });
  }

  /**
   * Fires when the user clicks 'change' on one of the children contact items.
   */
  startEdit() {
    // disable the existing contacts' controls while in add/edit mode
    this.contactItems.forEach(x => x.enableMyControls = false);
  }

  /**
   * Fires when an edit of one of the children contact items is abandoned.
   */
  abandonEdit() {
    this.contactItems.forEach(x => x.enableMyControls = true);
  }

  /**
   * Fires when a contact's edit is complete.
   */
  editContact(contact: User) {
    this.assessSvc.updateContact(contact).subscribe();
  }

  dropContact(contact: User) {
    this.contacts.splice(
      this.contacts.findIndex(c => c.UserId === contact.UserId),
      1
    );
    // zero on the assessement_id implies the current assessment
    this.assessSvc.removeContact(contact.UserId, 0).subscribe(
      (response: { ContactList: User[] }) => { this.changeOccurred(); },
      error => {
        this.dialog
          .open(AlertComponent, { data: "Error removing assessment contact" })
          .afterClosed()
          .subscribe();
        console.log(
          "Error removing assessment contact: " + JSON.stringify(contact)
        );
      }
    );
  }

  openEmailDialog() {
    const invitees: User[] = [];
    const allInvitees: User[] = [];
    const subject = this.configSvc.config.defaultInviteSubject;
    const body = this.configSvc.config.defaultInviteTemplate;
    for (const c of this.contacts) {
      // Don't send invite email to yourself, or anyone already invited
      if (
        c.PrimaryEmail &&
        c.PrimaryEmail !== this.auth.email() &&
        !c.Invited
      ) {
        invitees.push(c);
      }
      allInvitees.push(c);
    }

    this.emailDialog = this.dialog.open(EmailComponent, {
      data: {
        showContacts: true,
        contacts: invitees,
        potentialContacts: allInvitees,
        subject: subject,
        body: body
      }
    });
    this.emailDialog.afterClosed().subscribe(x => {
      for (const c of invitees) {
        c.Invited = x[c.PrimaryEmail];
      }
    });
  }

  showControls() {
    if (this.userRole === 2) {
      return true;
    }
    return false;
  }
}
