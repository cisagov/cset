import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewAssessmentDialogComponent } from './new-assessment-dialog.component';

describe('NewAssessmentDialogComponent', () => {
  let component: NewAssessmentDialogComponent;
  let fixture: ComponentFixture<NewAssessmentDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NewAssessmentDialogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NewAssessmentDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
