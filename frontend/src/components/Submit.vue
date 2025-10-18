<script setup>
import { ref } from "vue";

defineProps({
  msg: String,
});

const meal = ref("");
const mealInput = ref("");

function submit() {
  alert("已提交！");
  meal.value = mealInput.value;
}
</script>

<template>
  <h2>{{ msg }}</h2>
  <input v-model="mealInput" type="text" placeholder="enter my meal..." />
  <button @click="submit" id="submit"></button>

  <div class="menu">
    <!-- <button type="button" @click="count++">count is {{ count }}</button> -->
    <!-- <span class="meal">菜菜</span> -->
    <span class="meal">{{ meal }}</span>
  </div>
</template>

<style scoped></style>
