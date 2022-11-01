import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MvraAnswerFunctionsComponent } from './mvra-answer-functions.component';

describe('MvraAnswerFunctionsComponent', () => {
  let component: MvraAnswerFunctionsComponent;
  let fixture: ComponentFixture<MvraAnswerFunctionsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MvraAnswerFunctionsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MvraAnswerFunctionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
