import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrIntroAboutComponent } from './crr-intro-about.component';

describe('CrrIntroAboutComponent', () => {
  let component: CrrIntroAboutComponent;
  let fixture: ComponentFixture<CrrIntroAboutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrIntroAboutComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrIntroAboutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
