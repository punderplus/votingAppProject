import { LightningElement, api, track } from 'lwc';
import isVoted from '@salesforce/apex/QuestionsForCampaignController.isVoted';
import getQuestions from '@salesforce/apex/QuestionsForCampaignController.getQuestions';
import getAnswers from '@salesforce/apex/QuestionsForCampaignController.getAnswers';
import isInProgress from '@salesforce/apex/QuestionsForCampaignController.isInProgress';
import addVotes from '@salesforce/apex/VoteController.addVotes';
import uId from '@salesforce/user/Id';
export default class QuizForm extends LightningElement {
    isInProgress = true;
    showform = false;
    @api recordId;
    @track questions;
    answers;
    @track listKey = 1;
    @track questionIds = [];
    @track answersForQuestions = [];

    @track options;
    async connectedCallback() {
        this.isInProgress = await isInProgress({ cmpId: this.recordId });
        this.showform = await isVoted({ userId: uId, cmpId: this.recordId });
        this.questions = await getQuestions({ cmpId: this.recordId });
        this.questions.forEach(item => {
            this.answersForQuestions.push({ 'question': item, 'options': [] });
            this.questionIds.push(item.Id);
        });
        console.log(this.answersForQuestions);
        this.answers = await getAnswers({ questionsList: this.questionIds });
        this.answersForQuestions.forEach(item => {
            this.answers.forEach(answer => {
                if (item.question.Id === answer.Question__c) {
                    item.options.push({ 'label': answer.Option__r.Name, 'value': answer.Option__r.Id });
                }
            });
        })
    }
    @track answersList = [];
    handleClick() {
        let input = this.template.querySelectorAll("lightning-radio-group");
        input.forEach(item => {
            this.answersList.push({ 'question': item.name, 'option': item.value });
        });
        console.log(this.answersList);
        addVotes({ userId: uId, cmpId: this.recordId, questionsAndAnswers: this.answersList }).then(response => console.log(response)).catch(error => {
            console.log(error);
        });
        input.forEach(item => { item.disabled = true });
        this.showform = false;
    }

}