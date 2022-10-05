import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LogoTsaComponent } from './logo-tsa.component';

describe('LogoTsaComponent', () => {
  let component: LogoTsaComponent;
  let fixture: ComponentFixture<LogoTsaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ LogoTsaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LogoTsaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
