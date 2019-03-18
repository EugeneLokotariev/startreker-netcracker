import { Component, OnInit } from '@angular/core';
import { FormGroup, Validators, FormBuilder } from '@angular/forms';
import { ApiUserService } from '../../services/auth.service';
import { LoginFormData } from '../../services/interfaces/login-form.interface';
import { LoginResponse } from '../../services/interfaces/login-response.interface';
import { MessageService } from "primeng/api";
import { ShowMessageService} from '../admin/approver/shared/service/show-message.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
  providers: [ShowMessageService]
})
export class LoginComponent implements OnInit {

  loginForm: FormGroup;
  formData: LoginFormData;
  submitted = false;
  submitBut = false;

  usernameMinLength = 3;
  usernameMaxLength = 24;
  passwrodMinLength = 6;
  passwrodMaxLength = 64;

  constructor(
    private apiService: ApiUserService,
    private formBuilder: FormBuilder,
    private messageService: MessageService,
    private showMsgSrvc: ShowMessageService,
    private router: Router
  ) {
    this.loginForm = this.formBuilder.group({
      username: ['', [Validators.required, Validators.minLength(this.usernameMinLength), Validators.maxLength(this.usernameMaxLength)]],
      password: ['', [Validators.required, Validators.minLength(this.passwrodMinLength), Validators.maxLength(this.passwrodMaxLength)]]
    })
  }

  get f() {
    return this.loginForm.controls;
  }

  onSubmit() {
    this.submitted = true;
    if (this.loginForm.invalid) {
      return;
    }
    this.submitBut = true;
    this.formData = this.loginForm.value;
    this.apiService.loginUser(this.formData)
                    .subscribe((userData: LoginResponse) => {
                      this.apiService.getLoggedUser(userData);
                      this.submitBut = false;
                      this.router.navigateByUrl('/in-design');
                    },
                    error => {
                      if(error.error.error == 'UNAUTHORIZED'){
                        this.showMsgSrvc.showMessage(this.messageService, 
                                                    'error', 
                                                    'Wrong password or username', 
                                                    'Please check entered data');
                      }
                      this.submitBut = false;
                    });
  }

  ngOnInit() {
  }

}
