import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MvraAnswerDomainsComponent } from './mvra-answer-domains.component';

describe('MvraAnswerDomainsComponent', () => {
  let component: MvraAnswerDomainsComponent;
  let fixture: ComponentFixture<MvraAnswerDomainsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MvraAnswerDomainsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MvraAnswerDomainsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
