////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit, ViewChildren } from "@angular/core";
import { finalize } from 'rxjs/operators';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { TranslocoService } from "@jsverse/transloco";
import { AlertComponent } from "../../../../dialogs/alert/alert.component";
import { ConfirmComponent } from "../../../../dialogs/confirm/confirm.component";
import { EmailComponent } from "../../../../dialogs/email/email.component";
import { AssessmentContactsResponse } from "../../../../models/assessment-info.model";
import { EditableUser } from "../../../../models/editable-user.model";
import { User } from "../../../../models/user.model";
import { AssessmentService } from "../../../../services/assessment.service";
import { AuthenticationService } from "../../../../services/authentication.service";
import { ConfigService } from "../../../../services/config.service";
import { LayoutService } from "../../../../services/layout.service";
import { ContactItemComponent } from "./contact-item/contact-item.component";
import { ContactsService } from "../../../../services/contacts.service";

@Component({
  selector: "app-assessment-contacts",
  templateUrl: "./assessment-contacts.component.html",
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' },
  standalone: false
})
export class AssessmentContactsComponent implements OnInit {
  @Input() impliedSave: boolean = false;

  contacts: EditableUser[] = [];
  emailDialog: MatDialogRef<EmailComponent>;
  userRole: any;
  userEmail: string;
  editInProgress: boolean = false;
  private creatorId: number | null = null;


  // all child contact item components
  @ViewChildren(ContactItemComponent) contactItems: ContactItemComponent[];


  constructor(
    private contactsSvc: ContactsService,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService,
    private auth: AuthenticationService,
    private dialog: MatDialog,
    public layoutSvc: LayoutService,
    private tSvc: TranslocoService
  ) { }

  ngOnInit() {
    if (this.assessSvc.id()) {
      // Fetch creator ID first
      this.assessSvc.getCreator().then((creatorId: any) => {
        this.creatorId = creatorId;

        // Then fetch contacts
        return this.assessSvc.getAssessmentContacts();
      }).then((data: AssessmentContactsResponse) => {
        this.contacts = [];
        for (const c of data.contactList) {
          this.contacts.push(new EditableUser(c));
        }

        // broadcast the up-to-date list of contacts
        this.contactsSvc.contactsUpdated(this.contacts);

        this.userRole = data.currentUserRole;
        this.userEmail = this.auth.email();

        // Apply sorting with creator first
        this.sortContactsWithCreatorFirst();
      }).catch(error => {
        console.error('Error loading contacts:', error);
      });
    }
  }

  private sortContactsWithCreatorFirst(): void {
    if (!this.creatorId || this.contacts.length === 0) {
      return;
    }

    // Find creator contact
    const creatorIndex = this.contacts.findIndex(
      contact => contact.userId === this.creatorId
    );

    if (creatorIndex > 0) {
      // Move creator to top
      const [creator] = this.contacts.splice(creatorIndex, 1);
      this.contacts.unshift(creator);
    }

    // Find current user (if different from creator)
    const currentUserEmail = this.auth.email()?.toUpperCase();
    const currentUserIndex = this.contacts.findIndex(
      (contact, index) =>
        index > 0 && // Skip if already at position 0 (creator)
        contact.primaryEmail?.toUpperCase() === currentUserEmail
    );

    if (currentUserIndex > 1) {
      // Move current user to position 1 (after creator)
      const [currentUser] = this.contacts.splice(currentUserIndex, 1);
      this.contacts.splice(1, 0, currentUser);
    }

    // Mark first contact with isFirst flag
    if (this.contacts.length > 0) {
      this.contacts[0].isFirst = true;
    }
  }

  moveUser() {
    // move the user's contact to the top of the list
    const myIndex = this.contacts.findIndex(
      contact => contact.primaryEmail.toUpperCase() === this.auth.email().toUpperCase()
    );
    this.contacts.unshift(this.contacts.splice(myIndex, 1)[0]);
    this.contacts[0].isFirst = true;
  }

  hasNewContact() {
    if (this.contacts && this.contacts.length >= 1) {
      return !this.contacts[this.contacts.length - 1].userId;
    }
    return false;
  }

  /**
   * User just clicked 'add contact'
   */
  newContact() {
    this.editInProgress = true;

    // disable the existing contacts' controls while in add/edit mode
    this.contactItems.forEach(x => x.enableMyControls = false);

    this.contacts.push(
      new EditableUser({
        assessmentRoleId: 1,
        isPrimaryPoc: false,
        isSiteParticipant: false
      })
    );
  }

  /**
   * User just clicked 'Save' in the add/edit dialog area
   */
  saveNewContact(contact: EditableUser) {
    this.contacts[this.contacts.length - 1] = contact;

    this.assessSvc.createContact(contact)
      .pipe(
        finalize(() => {
          // Always runs after success or error
          this.editInProgress = false;

          // done adding - show the contacts' controls
          this.contactItems.forEach(x => x.enableMyControls = true);
        })
      )
      .subscribe(
        (response: { contactList: User[] }) => {
          const returnContact = response.contactList[0];
          contact.contactId = returnContact.contactId;
          contact.userId = returnContact.userId;
          contact.assessmentContactId = returnContact.assessmentContactId;
          contact.assessmentId = returnContact.assessmentId;
          contact.contactId = returnContact.contactId;

          this.sortContactsWithCreatorFirst();
          this.refreshContacts();
        },
        error => {
          this.dialog
            .open(AlertComponent, {
              data: "Error adding assessment contact: " + error
            })
            .afterClosed()
            .subscribe();
          console.error(
            "Error adding assessment contact: " + JSON.stringify(contact)
          );
        }
      );
  }

  /**
   * This fires when the user clicks the trashcan icon of an existing contact
   * or cancels out of the add dialog.
   */
  removeContact(contact: EditableUser, indx: number) {
    this.contactItems.forEach(x => x.enableMyControls = true);

    if (this.editInProgress && contact.isNew) {
      this.contacts.splice(indx, 1);
      this.editInProgress = false;
      this.refreshContacts();
      return;
    }

    this.editInProgress = false;
    if (contact.firstName === undefined
      || contact.lastName === undefined
      || contact.primaryEmail === undefined
    ) {
      this.dropContact(contact);
      this.refreshContacts();
      return;
    }

    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      this.tSvc.translate('dialogs.remove contact', { firstName: contact.firstName, lastName: contact.lastName });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropContact(contact);
        this.refreshContacts();
      }
    });
  }

  /**
   * Fires when the user clicks 'change' on one of the children contact items.
   */
  startEdit() {
    this.editInProgress = true;
    // disable the existing contacts' controls while in add/edit mode
    this.contactItems.forEach(x => x.enableMyControls = false);
  }

  /**
   * Fires when an edit of one of the children contact items is abandoned.
   */
  abandonEdit() {
    this.editInProgress = false;
    this.contactItems.forEach(x => x.enableMyControls = true);
  }

  /**
   * Fires when a contact's edit is complete.
   */
  editContact(contact: User) {
    this.assessSvc
      .getAssessmentContacts()
      .then((data: AssessmentContactsResponse) => {

        if (data.currentUserRole != 2) {
          console.error("User does not have the correct role to edit");
          return;
        }

        this.assessSvc.updateContact(contact)
          .pipe(
            finalize(() => {
              // Always runs after success or error
              this.editInProgress = false;
            })
          )
          .subscribe({
            next: (data: any) => {
              if (data && data.userId != contact.userId) {
                // Update the userId in case changing email linked to new user in backend
                const found = this.contacts.find(x => x.userId === contact.userId);
                if (found != null) {
                  found.userId = data.userId;
                }
              }
              this.contactItems.forEach(x => x.enableMyControls = true);
              this.sortContactsWithCreatorFirst();
              this.refreshContacts();
            },
            error: (error: any) => {
              console.error(error);
            }
          });
      });
  }

  /**
   * Calls ngOnInit to rebuild and broadcast the new list.
   */
  refreshContacts() {
    this.ngOnInit();
  }

  /**
   * Removes a contact from the assessment.
   */
  dropContact(contact: User) {
    // modify the client array
    this.contacts.splice(
      this.contacts.findIndex(c => c.assessmentContactId === contact.assessmentContactId),
      1
    );

    // if canceling out of an add attempt don't call the API
    if (contact.assessmentContactId == null) {
      return;
    }

    // update the API
    this.assessSvc.removeContact(contact.assessmentContactId).subscribe(
      (response: { contactList: User[] }) => {
        this.sortContactsWithCreatorFirst();
        this.refreshContacts();
      },
      error => {
        this.dialog
          .open(AlertComponent, { data: { title: "Error removing assessment contact" } })
          .afterClosed()
          .subscribe();
        console.error(
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
        c.primaryEmail &&
        c.primaryEmail !== this.auth.email() &&
        !c.invited
      ) {
        invitees.push(c);
      }
      allInvitees.push(c);
    }

    this.emailDialog = this.dialog.open(EmailComponent, {
      width: this.layoutSvc.hp ? '90%' : '',
      maxWidth: this.layoutSvc.hp ? '90%' : '',
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
        c.invited = x[c.primaryEmail];
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
