<script setup>
import { ref } from "vue";
import { postMeal } from "./api.js";

defineProps({
  msg: String,
});

const meal = ref("");
const mealInput = ref("");

function submit() {
  console.log("Submitted meal:", mealInput.value);
  meal.value = mealInput.value;
  mealInput.value = "";
  submitMeal();
}

async function submitMeal() {
  try {
    const res = await postMeal(meal.value);
    console.log("Server response:", res);
    result.value = res.status || "unknown";
  } catch (err) {
    result.value = "提交失败";
  }
}
</script>

<template>
  <h2>{{ msg }}</h2>
  <input
    @keyup.enter="submit"
    v-model="mealInput"
    type="text"
    placeholder="enter my meal..."
  />
  <button @click="submit" id="submit"></button>

  <div class="menu">
    <!-- <button type="button" @click="count++">count is {{ count }}</button> -->
    <!-- <span class="meal">菜菜</span> -->
    <span class="meal">{{ meal }}</span>
  </div>
</template>

<style scoped></style>
