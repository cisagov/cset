import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { AskQuestionsComponent } from './ask-questions.component';

describe('AskQuestionsComponent', () => {
  let component: AskQuestionsComponent;
  let fixture: ComponentFixture<AskQuestionsComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AskQuestionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AskQuestionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
